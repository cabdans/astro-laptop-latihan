// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  redirects: {
    '/review/budget/advan-workplus-r5-6600h': '/review/produktivitas/advan-workplus-r5-6600h',
    '/review/budget/advan-workplus-heritage-r5-7535hs': '/review/produktivitas/advan-workplus-heritage-r5-7535hs',
    // Axioo Pongo 765 & 765 V2 dipindah dari gaming/ ke high-gaming/ (Sesi 3, Opsi A) — jaga URL lama tetap hidup
    '/review/gaming/axioo-pongo-765': '/review/high-gaming/axioo-pongo-765',
    '/review/gaming/axioo-pongo-765-v2': '/review/high-gaming/axioo-pongo-765-v2',
  }
});
