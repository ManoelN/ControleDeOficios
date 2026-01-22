import { Mail, Phone, Globe } from 'lucide-react';

export function Footer() {
  return (
    <footer className="bg-gray-800 text-gray-200 mt-16">
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col items-center">
          <div className="mb-6">
            <img
              src="/Logo Preta DevnorTI.png"
              alt="DevnorTI Logo"
              className="h-16 w-auto bg-white rounded-lg px-4 py-2"
            />
          </div>

          <div className="text-center mb-6">
            <h3 className="text-lg font-semibold mb-2">Desenvolvido por DevnorTI</h3>
            <p className="text-sm text-gray-400 mb-1">CNPJ: 61.865.676/0001-32</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-3xl text-center md:text-left">
            <div className="flex flex-col items-center md:items-start">
              <div className="flex items-center gap-2 mb-2">
                <Mail className="w-5 h-5 text-blue-400" />
                <span className="font-semibold">E-mail</span>
              </div>
              <a
                href="mailto:devnortipin@gmail.com"
                className="text-sm text-gray-300 hover:text-blue-400 transition-colors"
              >
                devnortipin@gmail.com
              </a>
            </div>

            <div className="flex flex-col items-center md:items-start">
              <div className="flex items-center gap-2 mb-2">
                <Phone className="w-5 h-5 text-blue-400" />
                <span className="font-semibold">Telefones</span>
              </div>
              <div className="text-sm text-gray-300 space-y-1">
                <p>(92) 99453-4335</p>
                <p>(92) 98590-1594</p>
                <p>(92) 99274-9042</p>
              </div>
            </div>

            <div className="flex flex-col items-center md:items-start">
              <div className="flex items-center gap-2 mb-2">
                <Globe className="w-5 h-5 text-blue-400" />
                <span className="font-semibold">Website</span>
              </div>
              <a
                href="https://www.devnorti.com.br"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-gray-300 hover:text-blue-400 transition-colors"
              >
                www.devnorti.com.br
              </a>
            </div>
          </div>

          <div className="mt-8 pt-6 border-t border-gray-700 w-full text-center">
            <p className="text-sm text-gray-400">
              © {new Date().getFullYear()} DevnorTI. Todos os direitos reservados.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}
