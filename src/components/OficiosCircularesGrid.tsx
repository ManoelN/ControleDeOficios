import { Check, Lock, Search, Zap } from 'lucide-react';
import { OficioCircular } from '../lib/supabase';
import { useState } from 'react';
import { ConfirmModal } from './ConfirmModal';

interface OficiosCircularesGridProps {
  oficios: OficioCircular[];
  onMarcarOficio: (numero: number, status: 'disponivel' | 'utilizado' | 'bloqueado', descricao?: string) => Promise<void>;
  onMarcarProximo: (descricao?: string) => Promise<number | null>;
  loading: boolean;
}

export function OficiosCircularesGrid({ oficios, onMarcarOficio, onMarcarProximo, loading }: OficiosCircularesGridProps) {
  const [searchTerm, setSearchTerm] = useState('');
  const [showOnlyAvailable, setShowOnlyAvailable] = useState(false);
  const [processingNumero, setProcessingNumero] = useState<number | null>(null);
  const [confirmAction, setConfirmAction] = useState<{
    numero: number;
    acao: 'marcar' | 'desmarcar';
  } | null>(null);

  const handleClick = (oficio: OficioCircular) => {
    if (processingNumero || oficio.status === 'bloqueado') return;

    const acao = oficio.status === 'disponivel' ? 'marcar' : 'desmarcar';
    setConfirmAction({ numero: oficio.numero, acao });
  };

  const handleConfirm = async (descricao: string) => {
    if (!confirmAction) return;

    const oficio = oficios.find((o) => o.numero === confirmAction.numero);
    if (!oficio) return;

    const novoStatus = oficio.status === 'disponivel' ? 'utilizado' : 'disponivel';

    setConfirmAction(null);
    setProcessingNumero(confirmAction.numero);

    try {
      await onMarcarOficio(confirmAction.numero, novoStatus, descricao);
    } catch (error) {
      console.error('Erro ao marcar ofício circular:', error);
    } finally {
      setProcessingNumero(null);
    }
  };

  const handleCancel = () => {
    setConfirmAction(null);
  };

  const handleMarcarProximo = async () => {
    if (processingNumero) return;

    setProcessingNumero(-1);
    try {
      const numero = await onMarcarProximo();
      if (numero) {
        const element = document.getElementById(`oficio-circular-${numero}`);
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      }
    } finally {
      setProcessingNumero(null);
    }
  };

  const filteredOficios = oficios.filter((o) => {
    if (searchTerm) {
      const matchesNumero = o.numero.toString().includes(searchTerm);
      const matchesDescricao = o.descricao?.toLowerCase().includes(searchTerm.toLowerCase());
      if (!matchesNumero && !matchesDescricao) return false;
    }
    if (showOnlyAvailable && o.status !== 'disponivel') return false;
    return true;
  });

  const stats = {
    total: oficios.length,
    utilizados: oficios.filter((o) => o.status === 'utilizado').length,
    disponiveis: oficios.filter((o) => o.status === 'disponivel').length,
  };

  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-12 text-center">
        <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <p className="mt-4 text-gray-600">Carregando ofícios circulares...</p>
      </div>
    );
  }

  return (
    <>
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="mb-6 space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg p-4 border border-blue-200">
              <div className="text-sm text-blue-600 font-medium mb-1">Total de Ofícios Circulares</div>
              <div className="text-3xl font-bold text-blue-700">{stats.total}</div>
            </div>
            <div className="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-lg p-4 border border-yellow-200">
              <div className="text-sm text-yellow-600 font-medium mb-1">Utilizados</div>
              <div className="text-3xl font-bold text-yellow-700">{stats.utilizados}</div>
            </div>
            <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-lg p-4 border border-green-200">
              <div className="text-sm text-green-600 font-medium mb-1">Disponíveis</div>
              <div className="text-3xl font-bold text-green-700">{stats.disponiveis}</div>
            </div>
          </div>

          <div className="flex flex-col gap-3">
            <div className="flex flex-col sm:flex-row gap-3">
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  type="text"
                  placeholder="Buscar por número ou descrição..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              <button
                onClick={handleMarcarProximo}
                disabled={processingNumero !== null || stats.disponiveis === 0}
                className="flex items-center justify-center gap-2 bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap"
              >
                <Zap className="w-5 h-5" />
                Marcar Próximo Disponível
              </button>
            </div>

            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="showOnlyAvailable"
                checked={showOnlyAvailable}
                onChange={(e) => setShowOnlyAvailable(e.target.checked)}
                className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
              />
              <label htmlFor="showOnlyAvailable" className="text-sm text-gray-700 cursor-pointer">
                Mostrar apenas ofícios circulares disponíveis
              </label>
            </div>
          </div>
        </div>

        <div className="mb-4 flex items-center gap-6 text-sm">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 bg-white border-2 border-gray-300 rounded"></div>
            <span className="text-gray-600">Disponível</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 bg-yellow-400 border-2 border-yellow-500 rounded flex items-center justify-center">
              <Check className="w-4 h-4 text-yellow-900" />
            </div>
            <span className="text-gray-600">Utilizado</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 bg-gray-300 border-2 border-gray-400 rounded flex items-center justify-center">
              <Lock className="w-4 h-4 text-gray-600" />
            </div>
            <span className="text-gray-600">Bloqueado</span>
          </div>
        </div>

        <div className="border rounded-lg overflow-hidden">
          <div className="grid grid-cols-5 sm:grid-cols-10 md:grid-cols-10 gap-0">
            {filteredOficios.map((oficio) => {
              const isProcessing = processingNumero === oficio.numero;
              const isDisabled = processingNumero !== null && !isProcessing;

              return (
                <button
                  key={oficio.id}
                  id={`oficio-circular-${oficio.numero}`}
                  onClick={() => handleClick(oficio)}
                  disabled={isDisabled || oficio.status === 'bloqueado'}
                  className={`
                    flex flex-col items-center justify-center border border-gray-200 p-2
                    font-semibold text-sm sm:text-base transition-all relative group min-h-[60px]
                    ${
                      oficio.status === 'disponivel'
                        ? 'bg-white hover:bg-blue-50 hover:border-blue-300 text-gray-700'
                        : ''
                    }
                    ${
                      oficio.status === 'utilizado'
                        ? 'bg-yellow-400 border-yellow-500 text-yellow-900 hover:bg-yellow-500'
                        : ''
                    }
                    ${
                      oficio.status === 'bloqueado'
                        ? 'bg-gray-300 border-gray-400 text-gray-600 cursor-not-allowed'
                        : ''
                    }
                    ${isProcessing ? 'animate-pulse' : ''}
                    ${isDisabled ? 'opacity-50 cursor-not-allowed' : ''}
                  `}
                >
                  <span className="relative z-10 font-bold">
                    {oficio.numero.toString().padStart(3, '0')}
                  </span>
                  {oficio.descricao && oficio.status === 'utilizado' && (
                    <span className="text-[9px] sm:text-[10px] mt-1 text-center text-yellow-900 font-medium line-clamp-2 px-1">
                      {oficio.descricao}
                    </span>
                  )}
                  {oficio.status === 'utilizado' && (
                    <Check className="absolute top-1 right-1 w-3 h-3 sm:w-4 sm:h-4 text-yellow-900" />
                  )}
                  {oficio.status === 'bloqueado' && (
                    <Lock className="absolute top-1 right-1 w-3 h-3 sm:w-4 sm:h-4 text-gray-600" />
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {filteredOficios.length === 0 && searchTerm && (
          <div className="text-center py-8 text-gray-500">
            <p>Nenhum ofício circular encontrado com o número "{searchTerm}"</p>
          </div>
        )}
      </div>

      {confirmAction && (
        <ConfirmModal
          numero={confirmAction.numero}
          acao={confirmAction.acao}
          onConfirm={handleConfirm}
          onCancel={handleCancel}
        />
      )}
    </>
  );
}
