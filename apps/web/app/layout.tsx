import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'FazRepo - Package Manager Version Checker',
  description: 'A fast and efficient CLI tool to check package manager versions across npm, yarn, pnpm, and bun',
  keywords: ['cli', 'package-manager', 'npm', 'yarn', 'pnpm', 'bun', 'version-checker'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
} 