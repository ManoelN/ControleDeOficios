import { AlertCircle } from 'lucide-react';
import { useState } from 'react';

interface ConfirmModalProps {
  numero: number;
  acao: 'marcar' | 'desmarcar';
  onConfirm: (descricao: string) => void;
  onCancel: () => void;
}

export function ConfirmModal({ numero, acao, onConfirm, onCancel }: ConfirmModalProps) {
  const [descricao, setDescricao] = useState('');

  const handleConfirm = () => {
    onConfirm(descricao);
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full animate-scale-in">
        <div className="p-6">
          <div className="flex items-center justify-center mb-4">
            <div className="bg-blue-100 p-3 rounded-full">
              <AlertCircle className="w-8 h-8 text-blue-600" />
            </div>
          </div>

          <h2 className="text-xl font-bold text-gray-800 text-center mb-2">
            Confirmar Ação
          </h2>

          <p className="text-gray-600 text-center mb-4">
            {acao === 'marcar' ? (
              <>
                Tem certeza que deseja <strong className="text-blue-600">marcar</strong> o ofício{' '}
                <strong className="text-gray-900">nº {numero.toString().padStart(3, '0')}</strong> como utilizado?
              </>
            ) : (
              <>
                Tem certeza que deseja <strong className="text-orange-600">desmarcar</strong> o ofício{' '}
                <strong className="text-gray-900">nº {numero.toString().padStart(3, '0')}</strong>?
              </>
            )}
          </p>

          {acao === 'marcar' && (
            <div className="mb-6">
              <label htmlFor="descricao" className="block text-sm font-medium text-gray-700 mb-2">
                Descrição (opcional)
              </label>
              <input
                id="descricao"
                type="text"
                value={descricao}
                onChange={(e) => setDescricao(e.target.value)}
                placeholder="Ex: Enviado para Controladoria"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                autoFocus
              />
            </div>
          )}

          <div className="flex gap-3">
            <button
              onClick={onCancel}
              className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-semibold"
            >
              Não
            </button>
            <button
              onClick={handleConfirm}
              className={`flex-1 px-4 py-3 rounded-lg transition-colors font-semibold text-white ${
                acao === 'marcar'
                  ? 'bg-blue-600 hover:bg-blue-700'
                  : 'bg-orange-600 hover:bg-orange-700'
              }`}
            >
              Sim
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
