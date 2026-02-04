import type { Config } from 'tailwindcss';

export default {
    darkMode: 'class',
    content: ['./src/**/*.{html,js,svelte,ts}'],
    theme: {
        extend: {
            colors: {
                // Primary Indigo
                primary: {
                    DEFAULT: '#6366f1',
                    hover: '#4f46e5',
                    50: '#eef2ff',
                    100: '#e0e7ff',
                    200: '#c7d2fe',
                    300: '#a5b4fc',
                    400: '#818cf8',
                    500: '#6366f1',
                    600: '#4f46e5',
                    700: '#4338ca',
                    800: '#3730a3',
                    900: '#312e81'
                },

                // Background Ink
                background: {
                    light: '#f8fafc',
                    dark: '#0b0e14',
                    darker: '#06080a'
                },

                // Elevated Surfaces
                surface: {
                    light: '#ffffff',
                    dark: '#161b22',
                    darker: '#0d1117'
                },

                // Structural Borders
                border: {
                    light: '#e2e8f0',
                    dark: '#2a2d3d',
                    hover: '#3b3f54'
                },

                // Semantic Text
                text: {
                    primary: '#f8fafc',
                    secondary: '#94a3b8',
                    muted: '#64748b',
                    dark: '#0f172a'
                }
            },
            fontFamily: {
                display: ['Geist Mono', 'monospace'],
                body: ['Inter', 'sans-serif']
            },
            borderRadius: {
                DEFAULT: '0.375rem',
                lg: '0.5rem',
                xl: '0.75rem',
                '2xl': '1rem',
                full: '9999px'
            },
            boxShadow: {
                'primary-glow': '0 0 24px rgba(99, 102, 241, 0.15)',
                'primary-lg': '0 10px 40px -10px rgba(99, 102, 241, 0.25)'
            }
        }
    },
    plugins: []
} satisfies Config;
