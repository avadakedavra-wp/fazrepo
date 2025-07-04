export default {
  logo: <span>FazRepo Docs</span>,
  project: {
    link: 'https://github.com/avadakedavra-wp/fazrepo',
  },
  docsRepositoryBase: 'https://github.com/avadakedavra-wp/fazrepo/tree/main/apps/docs',
  footer: {
    text: 'FazRepo Documentation',
  },
  useNextSeoProps() {
    return {
      titleTemplate: '%s – FazRepo'
    }
  },
  head: (
    <>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta property="og:title" content="FazRepo Documentation" />
      <meta property="og:description" content="Documentation for FazRepo - A CLI tool to check package manager versions" />
    </>
  ),
} 