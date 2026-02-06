<script lang="ts">
    import { fade, fly, scale } from "svelte/transition";
    import { backOut } from "svelte/easing";

    let {
        isOpen = $bindable(false),
        title = "Are you sure?",
        message = "This action cannot be undone.",
        confirmText = "Confirm",
        cancelText = "Cancel",
        type = "danger", // 'danger' | 'info' | 'success'
        onConfirm = () => {},
        onClose = () => {},
    } = $props();

    function handleConfirm() {
        onConfirm();
        isOpen = false;
    }

    function handleClose() {
        onClose();
        isOpen = false;
    }
</script>

{#if isOpen}
    <div
        class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6"
    >
        <!-- Backdrop -->
        <div
            class="absolute inset-0 bg-slate-950/40 backdrop-blur-md"
            transition:fade={{ duration: 200 }}
            onclick={handleClose}
            role="button"
            tabindex="0"
            aria-label="Close modal"
            onkeydown={(e) => e.key === "Escape" && handleClose()}
        ></div>

        <!-- Modal Panel -->
        <div
            class="relative w-full max-w-md bg-white rounded-2xl shadow-2xl overflow-hidden border border-slate-200"
            transition:fly={{ y: 20, duration: 300, easing: backOut }}
        >
            <div class="p-6 sm:p-8">
                <div class="flex items-start gap-4">
                    <div
                        class="size-12 rounded-xl flex items-center justify-center shrink-0 {type ===
                        'danger'
                            ? 'bg-red-50 text-red-600'
                            : 'bg-primary/5 text-primary'}"
                    >
                        <span class="material-symbols-outlined text-2xl">
                            {type === "danger" ? "warning" : "info"}
                        </span>
                    </div>
                    <div class="space-y-1">
                        <h3
                            class="text-lg font-bold text-slate-900 leading-tight"
                        >
                            {title}
                        </h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            {message}
                        </p>
                    </div>
                </div>

                <div class="mt-8 flex flex-col sm:flex-row gap-3">
                    <button
                        class="flex-1 px-4 py-2.5 rounded-xl border border-slate-200 text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors uppercase tracking-widest"
                        onclick={handleClose}
                    >
                        {cancelText}
                    </button>
                    <button
                        class="flex-1 px-4 py-2.5 rounded-xl text-sm font-bold text-white transition-all uppercase tracking-widest shadow-lg {type ===
                        'danger'
                            ? 'bg-red-600 hover:bg-red-700 shadow-red-600/20'
                            : 'bg-primary hover:bg-primary-dark shadow-primary/20'}"
                        onclick={handleConfirm}
                    >
                        {confirmText}
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}
