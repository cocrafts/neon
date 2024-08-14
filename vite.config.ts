import { defineConfig } from 'vite';
import haxe from 'vite-plugin-haxe';
import topLevelAwait from 'vite-plugin-top-level-await';

export default defineConfig({
	plugins: [
		topLevelAwait({
			promiseExportName: '__tla',
			promiseImportName: (i) => `__lta_${i}`,
		}),
		haxe(),
	],
});
