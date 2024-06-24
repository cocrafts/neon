import type { SSTConfig } from 'sst';
import type { FunctionProps } from 'sst/constructs';

import landing from './src/site/stack';

export const functionDefaults: Partial<FunctionProps> = {
	runtime: 'nodejs20.x',
	architecture: 'arm_64',
	memorySize: 1024,
};

export default {
	config() {
		return {
			name: 'neon',
			region: 'ap-south-1',
		};
	},
	stacks(app) {
		app.setDefaultFunctionProps(functionDefaults);
		app.stack(landing);
	},
} satisfies SSTConfig;
