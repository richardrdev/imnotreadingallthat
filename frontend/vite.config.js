import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  root: 'src',
  base: '/static/',
  build: {
    outDir: '../dist',
    rollupOptions: {
      input: 'src/index.html',
    },
  },
});
