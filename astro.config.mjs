import { defineConfig } from 'astro/config';
import tailwind from "@astrojs/tailwind";
import sitemap from "@astrojs/sitemap";
import compress from "astro-compress";

import robotsTxt from "astro-robots-txt";

// https://astro.build/config
export default defineConfig({
  compressHTML: true,
  site: 'https://nolanpoe.me',
  integrations: [tailwind(), sitemap(), compress(), robotsTxt()]
});