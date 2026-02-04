import type { Config } from 'tailwindcss';

export default {
    darkMode: 'class',
    content: ['./src/**/*.{html,js,svelte,ts}'],
    theme: {
        extend: {
            colors: {
                // SaaS Data Table (Slate/Blue) Palette
                primary: {
                    DEFAULT: '#10b981', // Brand Green
                    hover: '#059669'
                },
                secondary: {
                    DEFAULT: '#64748b', // Slate Gray
                    hover: '#475569'
                },
                accent: {
                    DEFAULT: '#0ea5e9', // Sky Blue
                    hover: '#0284c7'
                },

                // Backgrounds (Clean Slate)
                background: {
                    light: '#ffffff',
                    dark: '#f8fafc',
                    darker: '#f1f5f9'
                },

                // Elevated Surfaces
                surface: {
                    light: '#ffffff',
                    dark: '#fbfcfd',
                    darker: '#f8fafc'
                },

                // Structural Borders
                border: {
                    light: '#f1f5f9',
                    dark: '#e2e8f0',
                    hover: '#cbd5e1'
                },

                // Semantic Text
                text: {
                    primary: '#0f172a',
                    main: '#0f172a',
                    secondary: '#475569',
                    muted: '#94a3b8',
                    dark: '#020617'
                }
            },
            fontFamily: {
                display: ['Inter', 'system-ui', 'sans-serif'],
                body: ['Inter', 'system-ui', 'sans-serif']
            },
            borderRadius: {
                DEFAULT: '0.375rem',
                lg: '0.5rem',
                xl: '0.75rem',
                '2xl': '1rem',
                full: '9999px'
            },
            boxShadow: {
                'primary-glow': '0 0 15px rgba(16, 185, 129, 0.1)',
                'saas-sm': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
                'saas-md': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
            }
        }
    },
    plugins: []
} satisfies Config;
