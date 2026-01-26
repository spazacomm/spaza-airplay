<script lang="ts">
    let { children } = $props();
</script>

<div
    class="min-h-screen bg-background-dark flex flex-col items-center justify-center p-4"
>
    <!-- Logo -->
    <div class="flex items-center gap-3 mb-8">
        <div
            class="size-12 rounded-full bg-gradient-to-tr from-primary to-emerald-600 flex items-center justify-center text-background-dark"
        >
            <span class="material-symbols-outlined text-3xl icon-fill"
                >equalizer</span
            >
        </div>
        <h1 class="font-bold text-3xl tracking-tight">Spaza Airplay</h1>
    </div>

    <!-- Content -->
    <div
        class="w-full max-w-md bg-surface-darker/50 backdrop-blur-sm border border-border-dark p-8 rounded-2xl shadow-primary-glow"
    >
        {@render children()}
    </div>

    <!-- Footer -->
    <div class="mt-8 text-center">
        <p class="text-text-muted text-sm">
            &copy; 2024 Spaza Airplay. Secure music analytics for Africa.
        </p>
    </div>
</div>
