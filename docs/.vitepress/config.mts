import { defineConfig } from 'vitepress'
import { generateSidebar } from 'vitepress-sidebar'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  lang: 'en-US',
  title: "Kube Workload Toolkit",
  description: "Deploy on Kubernetes with confidence using tested charts and clear recipes",
  // base: '/helm-charts/docs/',
  outDir: '../public',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Setup', link: '/setup' },
      { text: 'Application guides', link: '/application-guides' },
      { text: 'Custom charts', link: '/custom-charts' }
    ],
    // https://vitepress-sidebar.cdget.com/guide/options
    sidebar: generateSidebar({
      documentRootPath: '/docs',
      followSymlinks: true,
      collapsed: true,
      excludeByGlobPattern: ['examples'],
      useFolderLinkFromIndexFile: true,
      useFolderTitleFromIndexFile: true,
      useTitleFromFileHeading: true
    }),
    socialLinks: [
      { icon: 'github', link: 'https://github.com/devpro/helm-charts' }
    ],
    outline: false
  },
  markdown: {
    theme: {
      light: 'catppuccin-latte',
      dark: 'catppuccin-mocha',
    }
  }
})
