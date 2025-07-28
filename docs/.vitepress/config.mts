import { defineConfig } from 'vitepress'
import { generateSidebar } from 'vitepress-sidebar'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Devpro Helm Chart Guide",
  description: "A guide to make the best use of Helm charts to manage workload in Kubernetes clusters",
  base: '/helm-charts/docs/',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Catalog', link: '/catalog' },
      { text: 'Handcrafted', link: '/handcrafted' }
    ],
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
  }
})
