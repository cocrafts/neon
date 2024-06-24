import type { StackContext } from 'sst/constructs';
import { StaticSite } from 'sst/constructs';

export const hostedZone = 'metacraft.studio';
export const baseDomainName = 'metacraft.studio';

const landingAlias = {
	production: 'neon.',
	staging: 'stg.neon.',
	development: 'dev.neon.',
};

const landingDomainFromStage = (stage: string) => {
	const prefix = landingAlias[stage] || `${stage}.`;
	return `${prefix.trim()}${baseDomainName}`;
};

export const landing = ({ stack, app }: StackContext) => {
	const domainName = landingDomainFromStage(app.stage);

	const site = new StaticSite(stack as never, 'landing-static', {
		path: 'dist',
		customDomain: {
			domainName,
			hostedZone,
		},
	});

	stack.addOutputs({
		url: site.url || 'localhost',
		domainName,
	});
};

export default landing;
