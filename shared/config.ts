import domainsConfig from '../config/domains.json';

interface SiteConfig {
  domain: string;
  port: number;
  apiUrl: string;
}

interface DomainConfig {
  sites: {
    [key: string]: {
      local: SiteConfig;
      production: SiteConfig;
    };
  };
  environment: 'local' | 'production';
}

const config: DomainConfig = domainsConfig as DomainConfig;

export const getConfig = (siteName: string): SiteConfig => {
  const site = config.sites[siteName];
  if (!site) {
    throw new Error(`Site configuration for "${siteName}" not found`);
  }
  
  return site[config.environment];
};

export const getCurrentEnvironment = (): string => {
  return config.environment;
};

export const getAllSites = (): string[] => {
  return Object.keys(config.sites);
};

export const updateEnvironment = (env: 'local' | 'production'): void => {
  config.environment = env;
};

// Configuraciones específicas para cada sitio
export const getCorporativaConfig = (): SiteConfig => getConfig('corporativa');
export const getEyengaConfig = (): SiteConfig => getConfig('eyenga');

export default config;
