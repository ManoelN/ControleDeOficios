import { X } from 'lucide-react';
import { useState } from 'react';

interface CreateYearModalProps {
  onClose: () => void;
  onCreateYear: (year: number, quantidade: number) => Promise<void>;
  existingYears: number[];
}

export function CreateYearModal({ onClose, onCreateYear, existingYears }: CreateYearModalProps) {
  const [year, setYear] = useState(new Date().getFullYear());
  const [quantidade, setQuantidade] = useState(1500);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (existingYears.includes(year)) {
      setError('Este ano já existe no sistema');
      return;
    }

    if (year < 2000 || year > 2100) {
      setError('Ano inválido');
      return;
    }

    if (quantidade < 1 || quantidade > 9999) {
      setError('Quantidade deve ser entre 1 e 9999');
      return;
    }

    setLoading(true);
    try {
      await onCreateYear(year, quantidade);
      onClose();
    } catch (err) {
      setError('Erro ao criar ano. Tente novamente.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full">
        <div className="flex items-center justify-between p-6 border-b">
          <h2 className="text-xl font-bold text-gray-800">Criar Novo Ano</h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6">
          <div className="mb-4">
            <label htmlFor="year" className="block text-sm font-medium text-gray-700 mb-2">
              Ano
            </label>
            <input
              id="year"
              type="number"
              value={year}
              onChange={(e) => setYear(parseInt(e.target.value))}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              min="2000"
              max="2100"
              required
            />
          </div>

          <div className="mb-6">
            <label htmlFor="quantidade" className="block text-sm font-medium text-gray-700 mb-2">
              Quantidade de Ofícios
            </label>
            <input
              id="quantidade"
              type="number"
              value={quantidade}
              onChange={(e) => setQuantidade(parseInt(e.target.value))}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              min="1"
              max="9999"
              required
            />
            <p className="mt-2 text-sm text-gray-500">
              Informe quantos números de ofícios deseja criar (1 a 9.999)
            </p>
          </div>

          {error && (
            <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
              {error}
            </div>
          )}

          <div className="flex gap-3">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={loading}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Criando...' : 'Criar Ano'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
