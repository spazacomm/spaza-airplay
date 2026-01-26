import type { Config } from 'tailwindcss';

export default {
    darkMode: 'class',
    content: ['./src/**/*.{html,js,svelte,ts}'],
    theme: {
        extend: {
            colors: {
                // Primary accent
                primary: {
                    DEFAULT: '#13eca4',
                    hover: '#0fd693',
                    50: '#e8fef5',
                    100: '#c5fce6',
                    200: '#8ef9d0',
                    300: '#4ef0b6',
                    400: '#13eca4',
                    500: '#0bd68f',
                    600: '#06b076',
                    700: '#088c60',
                    800: '#0b6e4e',
                    900: '#0a5a42'
                },

                // Backgrounds
                background: {
                    light: '#f6f8f7',
                    dark: '#10221c',
                    darker: '#0d1a15'
                },

                // Surfaces
                surface: {
                    light: '#ffffff',
                    dark: '#1A2C26',
                    darker: '#111816'
                },

                // Borders
                border: {
                    light: '#e0e0e0',
                    dark: '#283933',
                    hover: '#3b544b'
                },

                // Text
                text: {
                    primary: '#ffffff',
                    secondary: '#9db9b0',
                    muted: '#5f7a70',
                    dark: '#111816'
                }
            },
            fontFamily: {
                display: ['Manrope', 'sans-serif'],
                body: ['Noto Sans', 'sans-serif']
            },
            borderRadius: {
                DEFAULT: '0.25rem',
                lg: '0.5rem',
                xl: '0.75rem',
                '2xl': '1rem',
                full: '9999px'
            },
            boxShadow: {
                'primary-glow': '0 0 20px rgba(19, 236, 164, 0.15)',
                'primary-lg': '0 10px 40px -10px rgba(19, 236, 164, 0.3)'
            }
        }
    },
    plugins: []
} satisfies Config;
