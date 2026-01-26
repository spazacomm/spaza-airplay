<script lang="ts">
    let { children } = $props();
</script>

<div class="relative flex min-h-screen flex-col bg-background-dark">
    <!-- Navbar -->
    <header
        class="sticky top-0 z-50 w-full border-b border-border-dark bg-background-dark/90 backdrop-blur-md"
    >
        <div
            class="px-4 md:px-10 py-3 max-w-[1280px] mx-auto w-full flex items-center justify-between"
        >
            <div class="flex items-center gap-4 text-white">
                <div class="text-primary">
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 32px;">graphic_eq</span
                    >
                </div>
                <h2
                    class="text-white text-xl font-bold leading-tight tracking-[-0.015em]"
                >
                    Spaza Airplay
                </h2>
            </div>
            <div class="hidden md:flex items-center gap-8">
                <div class="flex items-center gap-6">
                    <a
                        class="text-white text-sm font-medium hover:text-primary transition-colors"
                        href="#features">Features</a
                    >
                    <a
                        class="text-white text-sm font-medium hover:text-primary transition-colors"
                        href="#pricing">Pricing</a
                    >
                    <a
                        class="text-white text-sm font-medium hover:text-primary transition-colors"
                        href="/resources">Resources</a
                    >
                </div>
            </div>
            <div class="flex items-center gap-4">
                <a
                    class="hidden md:block text-white text-sm font-medium hover:text-primary transition-colors"
                    href="/login">Login</a
                >
                <button
                    class="flex cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-6 bg-primary text-background-dark text-sm font-bold hover:bg-primary-hover transition-colors"
                >
                    <span class="truncate">Get Started</span>
                </button>
            </div>
        </div>
    </header>

    <main class="flex-grow flex flex-col items-center w-full">
        {@render children()}
    </main>

    <!-- Footer -->
    <footer class="w-full">
        <div class="px-4 py-8 bg-surface-darker border-t border-border-dark">
            <div
                class="max-w-[1280px] mx-auto flex flex-col md:flex-row justify-between items-center gap-4"
            >
                <div class="flex items-center gap-2 text-white">
                    <div class="text-primary">
                        <span class="material-symbols-outlined">graphic_eq</span
                        >
                    </div>
                    <span class="font-bold">Spaza Airplay</span>
                </div>
                <div class="flex gap-6 text-sm text-text-secondary">
                    <a
                        class="hover:text-white transition-colors flex items-center gap-1"
                        href="/privacy"
                        >Privacy <span
                            class="material-symbols-outlined text-[14px]"
                            >chevron_right</span
                        ></a
                    >
                    <a
                        class="hover:text-white transition-colors flex items-center gap-1"
                        href="/terms"
                        >Terms <span
                            class="material-symbols-outlined text-[14px]"
                            >chevron_right</span
                        ></a
                    >
                    <a
                        class="hover:text-white transition-colors flex items-center gap-1"
                        href="/support"
                        >Support <span
                            class="material-symbols-outlined text-[14px]"
                            >chevron_right</span
                        ></a
                    >
                </div>
                <div class="text-sm text-text-muted">
                    &copy; 2024 Spaza Airplay. All rights reserved.
                </div>
            </div>
        </div>
    </footer>
</div>
