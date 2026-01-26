<script lang="ts">
    let { title = "Coming Soon" } = $props();
</script>

<div
    class="flex flex-col items-center justify-center min-h-[60vh] text-center p-8"
>
    <div
        class="size-20 rounded-full bg-surface-dark flex items-center justify-center text-primary mb-6"
    >
        <span class="material-symbols-outlined text-4xl">construction</span>
    </div>
    <h1 class="text-3xl font-bold mb-4">{title}</h1>
    <p class="text-text-secondary max-w-md mx-auto mb-8">
        We're working hard to bring you this feature. Check back soon for
        updates on your music royalty tracking.
    </p>
    <a href="/dashboard" class="btn-primary"> Return to Dashboard </a>
</div>
