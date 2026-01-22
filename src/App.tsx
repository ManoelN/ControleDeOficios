import { useState } from 'react';
import { Header } from './components/Header';
import { YearSelector } from './components/YearSelector';
import { OficiosGrid } from './components/OficiosGrid';
import { CapasGrid } from './components/CapasGrid';
import { OficiosCircularesGrid } from './components/OficiosCircularesGrid';
import { CreateYearModal } from './components/CreateYearModal';
import { TabNavigation } from './components/TabNavigation';
import { Footer } from './components/Footer';
import { LoginPage } from './components/LoginPage';
import { useAnos } from './hooks/useAnos';
import { useOficios } from './hooks/useOficios';
import { useAnosCapas } from './hooks/useAnosCapas';
import { useCapas } from './hooks/useCapas';
import { useAnosOficiosCirculares } from './hooks/useAnosOficiosCirculares';
import { useOficiosCirculares } from './hooks/useOficiosCirculares';
import { useAuth } from './hooks/useAuth';

function App() {
  const { user, loading: authLoading, error: authError, signIn, signOut } = useAuth();
  const [activeTab, setActiveTab] = useState<'oficios' | 'capas' | 'oficios-circulares'>('oficios');

  const { anos, loading: loadingAnos, criarAno } = useAnos();
  const { anos: anosCapas, loading: loadingAnosCapas, criarAno: criarAnoCapas } = useAnosCapas();
  const { anos: anosOficiosCirculares, loading: loadingAnosOficiosCirculares, criarAno: criarAnoOficiosCirculares } = useAnosOficiosCirculares();

  const [selectedAnoId, setSelectedAnoId] = useState<string | null>(null);
  const [selectedAnoCapasId, setSelectedAnoCapasId] = useState<string | null>(null);
  const [selectedAnoOficiosCircularesId, setSelectedAnoOficiosCircularesId] = useState<string | null>(null);
  const [showCreateModal, setShowCreateModal] = useState(false);

  const { oficios, loading: loadingOficios, marcarOficio, marcarProximoDisponivel } = useOficios(selectedAnoId);
  const { capas, loading: loadingCapas, marcarCapa, marcarProximoDisponivel: marcarProximaCapaDisponivel } = useCapas(selectedAnoCapasId);
  const { oficios: oficiosCirculares, loading: loadingOficiosCirculares, marcarOficio: marcarOficioCircular, marcarProximoDisponivel: marcarProximoOficioCircularDisponivel } = useOficiosCirculares(selectedAnoOficiosCircularesId);

  const handleSelectAno = (anoId: string) => {
    setSelectedAnoId(anoId);
  };

  const handleSelectAnoCapas = (anoId: string) => {
    setSelectedAnoCapasId(anoId);
  };

  const handleSelectAnoOficiosCirculares = (anoId: string) => {
    setSelectedAnoOficiosCircularesId(anoId);
  };

  const handleCreateAno = async (year: number, quantidade: number) => {
    if (activeTab === 'oficios') {
      const novoAno = await criarAno(year, quantidade);
      setSelectedAnoId(novoAno.id);
    } else if (activeTab === 'capas') {
      const novoAno = await criarAnoCapas(year, quantidade);
      setSelectedAnoCapasId(novoAno.id);
    } else {
      const novoAno = await criarAnoOficiosCirculares(year, quantidade);
      setSelectedAnoOficiosCircularesId(novoAno.id);
    }
  };

  const selectedAno = anos.find((a) => a.id === selectedAnoId);
  const selectedAnoCapas = anosCapas.find((a) => a.id === selectedAnoCapasId);
  const selectedAnoOficiosCirculares = anosOficiosCirculares.find((a) => a.id === selectedAnoOficiosCircularesId);

  const handleLogin = async (email: string, password: string) => {
    await signIn(email, password);
  };

  if (authLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 flex flex-col">
        <Header onLogout={signOut} />
        <div className="container mx-auto px-4 py-8 flex items-center justify-center min-h-[60vh] flex-1">
          <div className="text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
            <p className="text-gray-600">Verificando autenticação...</p>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  if (!user) {
    return <LoginPage onLogin={handleLogin} error={authError} loading={authLoading} />;
  }

  if (loadingAnos || loadingAnosCapas || loadingAnosOficiosCirculares) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 flex flex-col">
        <Header onLogout={signOut} />
        <div className="container mx-auto px-4 py-8 flex items-center justify-center min-h-[60vh] flex-1">
          <div className="text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
            <p className="text-gray-600">Carregando sistema...</p>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  const currentAnos = activeTab === 'oficios' ? anos : activeTab === 'capas' ? anosCapas : anosOficiosCirculares;
  const currentSelectedAnoId = activeTab === 'oficios' ? selectedAnoId : activeTab === 'capas' ? selectedAnoCapasId : selectedAnoOficiosCircularesId;
  const currentSelectedAno = activeTab === 'oficios' ? selectedAno : activeTab === 'capas' ? selectedAnoCapas : selectedAnoOficiosCirculares;
  const handleSelectCurrentAno = activeTab === 'oficios' ? handleSelectAno : activeTab === 'capas' ? handleSelectAnoCapas : handleSelectAnoOficiosCirculares;

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 flex flex-col">
      <Header onLogout={signOut} />

      <div className="container mx-auto px-4 py-8 flex-1">
        <TabNavigation activeTab={activeTab} onTabChange={setActiveTab} />

        <YearSelector
          anos={currentAnos}
          selectedAnoId={currentSelectedAnoId}
          onSelectAno={handleSelectCurrentAno}
          onCreateAno={() => setShowCreateModal(true)}
        />

        {currentSelectedAno && (
          <div className="mb-6">
            <h2 className="text-2xl font-bold text-gray-800 mb-2">
              {activeTab === 'oficios'
                ? `Ofícios do Ano ${currentSelectedAno.ano}`
                : activeTab === 'capas'
                ? `Capas de Processos do Ano ${currentSelectedAno.ano}`
                : `Ofícios Circulares do Ano ${currentSelectedAno.ano}`
              }
            </h2>
            <p className="text-gray-600">
              Clique em um número disponível para marcá-lo como utilizado.
              Clique em um número utilizado para desmarcá-lo.
            </p>
          </div>
        )}

        {currentSelectedAnoId ? (
          activeTab === 'oficios' ? (
            <OficiosGrid
              oficios={oficios}
              onMarcarOficio={marcarOficio}
              onMarcarProximo={marcarProximoDisponivel}
              loading={loadingOficios}
            />
          ) : activeTab === 'capas' ? (
            <CapasGrid
              capas={capas}
              onMarcarCapa={marcarCapa}
              onMarcarProximo={marcarProximaCapaDisponivel}
              loading={loadingCapas}
            />
          ) : (
            <OficiosCircularesGrid
              oficios={oficiosCirculares}
              onMarcarOficio={marcarOficioCircular}
              onMarcarProximo={marcarProximoOficioCircularDisponivel}
              loading={loadingOficiosCirculares}
            />
          )
        ) : (
          <div className="bg-white rounded-lg shadow-md p-12 text-center">
            <p className="text-gray-500 text-lg">
              {currentAnos.length === 0
                ? `Crie um novo ano para começar a usar o sistema de ${activeTab === 'oficios' ? 'ofícios' : activeTab === 'capas' ? 'capas' : 'ofícios circulares'}`
                : `Selecione um ano para visualizar ${activeTab === 'oficios' ? 'os ofícios' : activeTab === 'capas' ? 'as capas' : 'os ofícios circulares'}`}
            </p>
          </div>
        )}
      </div>

      <Footer />

      {showCreateModal && (
        <CreateYearModal
          onClose={() => setShowCreateModal(false)}
          onCreateYear={handleCreateAno}
          existingYears={currentAnos.map((a) => a.ano)}
        />
      )}
    </div>
  );
}

export default App;
