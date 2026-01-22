import { Plus, Calendar } from 'lucide-react';
import { Ano } from '../lib/supabase';

interface YearSelectorProps {
  anos: Ano[];
  selectedAnoId: string | null;
  onSelectAno: (anoId: string) => void;
  onCreateAno: () => void;
}

export function YearSelector({ anos, selectedAnoId, onSelectAno, onCreateAno }: YearSelectorProps) {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 mb-6">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2 text-gray-700">
          <Calendar className="w-5 h-5" />
          <h2 className="text-lg font-semibold">Selecionar Ano</h2>
        </div>
        <button
          onClick={onCreateAno}
          className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
        >
          <Plus className="w-4 h-4" />
          Novo Ano
        </button>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-3">
        {anos.map((ano) => (
          <button
            key={ano.id}
            onClick={() => onSelectAno(ano.id)}
            className={`
              p-4 rounded-lg font-semibold text-lg transition-all
              ${
                selectedAnoId === ano.id
                  ? 'bg-blue-600 text-white shadow-lg scale-105'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }
            `}
          >
            {ano.ano}
          </button>
        ))}
      </div>

      {anos.length === 0 && (
        <div className="text-center py-8 text-gray-500">
          <p>Nenhum ano cadastrado. Clique em "Novo Ano" para começar.</p>
        </div>
      )}
    </div>
  );
}
