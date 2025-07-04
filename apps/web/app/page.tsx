import Link from 'next/link'
import { Button, Card, Badge } from 'ui';

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-gray-900">FazRepo</h1>
            </div>
            <nav className="flex space-x-8">
              <Link href="/docs" className="text-gray-500 hover:text-gray-900">
                Docs
              </Link>
              <Link href="https://github.com/avadakedavra-wp/fazrepo" className="text-gray-500 hover:text-gray-900">
                GitHub
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center">
          <h1 className="text-4xl font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
            <span className="block">Check Package Manager</span>
            <span className="block text-blue-600">Versions Instantly</span>
          </h1>
          <p className="mt-3 max-w-md mx-auto text-base text-gray-500 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl">
            A blazing-fast CLI tool to check versions of npm, yarn, pnpm, and bun package managers. 
            Perfect for developers who need to verify their development environment setup.
          </p>
          <div className="mt-5 max-w-md mx-auto sm:flex sm:justify-center md:mt-8">
            <div className="rounded-md shadow">
              <Link
                href="/docs"
                className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 md:py-4 md:text-lg md:px-10"
              >
                Get Started
              </Link>
            </div>
            <div className="mt-3 rounded-md shadow sm:mt-0 sm:ml-3">
              <Link
                href="https://github.com/avadakedavra-wp/fazrepo"
                className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-blue-600 bg-white hover:bg-gray-50 md:py-4 md:text-lg md:px-10"
              >
                View on GitHub
              </Link>
            </div>
          </div>
        </div>

        {/* Features Section */}
        <div className="mt-20">
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-4">
            <div className="text-center">
              <div className="flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white mx-auto">
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
              <h3 className="mt-6 text-lg font-medium text-gray-900">Lightning Fast</h3>
              <p className="mt-2 text-base text-gray-500">
                Built in Rust for maximum performance and minimal resource usage.
              </p>
            </div>

            <div className="text-center">
              <div className="flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white mx-auto">
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 className="mt-6 text-lg font-medium text-gray-900">Cross Platform</h3>
              <p className="mt-2 text-base text-gray-500">
                Works seamlessly on Windows, macOS, and Linux with native support.
              </p>
            </div>

            <div className="text-center">
              <div className="flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white mx-auto">
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                </svg>
              </div>
              <h3 className="mt-6 text-lg font-medium text-gray-900">Multiple Managers</h3>
              <p className="mt-2 text-base text-gray-500">
                Supports npm, yarn, pnpm, and bun with detailed version information.
              </p>
            </div>

            <div className="text-center">
              <div className="flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white mx-auto">
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                </svg>
              </div>
              <h3 className="mt-6 text-lg font-medium text-gray-900">Simple CLI</h3>
              <p className="mt-2 text-base text-gray-500">
                Clean, intuitive command-line interface with colored output.
              </p>
            </div>
          </div>
        </div>

        {/* Installation Section */}
        <div className="mt-20 bg-white rounded-lg shadow-lg p-8">
          <h2 className="text-3xl font-bold text-gray-900 text-center mb-8">Quick Installation</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">Using Cargo</h3>
              <div className="bg-gray-900 rounded-lg p-4">
                <code className="text-green-400">cargo install fazrepo</code>
              </div>
            </div>
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">Using Homebrew</h3>
              <div className="bg-gray-900 rounded-lg p-4">
                <code className="text-green-400">brew install fazrepo</code>
              </div>
            </div>
          </div>
          <div className="mt-8 text-center">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Usage</h3>
            <div className="bg-gray-900 rounded-lg p-4 max-w-2xl mx-auto">
              <code className="text-green-400">fazrepo check</code>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-800">
        <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <p className="text-base text-gray-400">
              &copy; 2024 FazRepo. Built with ❤️ using Rust and Next.js.
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}