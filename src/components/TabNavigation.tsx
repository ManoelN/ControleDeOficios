import { FileText, FolderOpen, Repeat } from 'lucide-react';

interface TabNavigationProps {
  activeTab: 'oficios' | 'capas' | 'oficios-circulares';
  onTabChange: (tab: 'oficios' | 'capas' | 'oficios-circulares') => void;
}

export function TabNavigation({ activeTab, onTabChange }: TabNavigationProps) {
  return (
    <div className="bg-white rounded-lg shadow-md p-2 mb-6">
      <div className="grid grid-cols-3 gap-2">
        <button
          onClick={() => onTabChange('oficios')}
          className={`
            flex items-center justify-center gap-2 px-4 py-3 rounded-lg
            font-semibold transition-all
            ${
              activeTab === 'oficios'
                ? 'bg-blue-600 text-white shadow-md'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }
          `}
        >
          <FileText className="w-5 h-5" />
          <span className="hidden sm:inline">Ofícios</span>
        </button>
        <button
          onClick={() => onTabChange('oficios-circulares')}
          className={`
            flex items-center justify-center gap-2 px-4 py-3 rounded-lg
            font-semibold transition-all
            ${
              activeTab === 'oficios-circulares'
                ? 'bg-blue-600 text-white shadow-md'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }
          `}
        >
          <Repeat className="w-5 h-5" />
          <span className="hidden sm:inline">Ofícios Circulares</span>
        </button>
        <button
          onClick={() => onTabChange('capas')}
          className={`
            flex items-center justify-center gap-2 px-4 py-3 rounded-lg
            font-semibold transition-all
            ${
              activeTab === 'capas'
                ? 'bg-blue-600 text-white shadow-md'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }
          `}
        >
          <FolderOpen className="w-5 h-5" />
          <span className="hidden sm:inline">Capas</span>
        </button>
      </div>
    </div>
  );
}
