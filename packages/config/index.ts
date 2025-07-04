export const APP_CONFIG = {
  name: 'FazRepo',
  version: '0.2.0',
  description: 'A CLI tool to check package manager versions',
  repository: 'https://github.com/avadakedavra-wp/fazrepo',
  homepage: 'https://fazrepo.dev',
  keywords: ['cli', 'package-manager', 'npm', 'yarn', 'pnpm', 'bun'],
  supportedPackageManagers: ['npm', 'yarn', 'pnpm', 'bun'] as const,
} as const

export const PORTS = {
  web: 3000,
  docs: 3001,
} as const

export type SupportedPackageManager = typeof APP_CONFIG.supportedPackageManagers[number] 