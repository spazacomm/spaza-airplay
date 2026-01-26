<script lang="ts">
    import { goto } from "$app/navigation";

    let selectedType = $state("artist");

    function selectType(type: string) {
        selectedType = type;
    }

    async function handleContinue() {
        // In a real app, update profile with selected account type
        goto("/onboarding/step-2");
    }
</script>

<svelte:head>
    <title>Account Type | Spaza Airplay Onboarding</title>
</svelte:head>

<div
    class="flex flex-col items-center justify-center min-h-[calc(100vh-80px)] px-4 py-12 max-w-[1200px] mx-auto w-full"
>
    <!-- Onboarding Progress -->
    <div class="w-full max-w-[500px] mb-12">
        <div class="flex flex-col gap-3">
            <div class="flex gap-6 justify-between items-end">
                <p
                    class="text-white text-sm font-semibold uppercase tracking-widest"
                >
                    Step 1 of 4
                </p>
                <p class="text-primary text-sm font-bold">25% Complete</p>
            </div>
            <div class="rounded-full bg-white/10 h-2 w-full overflow-hidden">
                <div
                    class="h-full rounded-full bg-primary transition-all duration-500"
                    style="width: 25%;"
                ></div>
            </div>
            <p class="text-text-secondary text-xs font-medium">
                Account Configuration
            </p>
        </div>
    </div>

    <!-- Headline & Body -->
    <div class="text-center mb-10">
        <h1
            class="text-white tracking-tight text-3xl md:text-4xl font-extrabold leading-tight mb-4"
        >
            Tell us about yourself
        </h1>
        <p class="text-text-secondary text-lg max-w-xl mx-auto">
            Select your account type to help us tailor your royalty dashboard to
            your specific needs.
        </p>
    </div>

    <!-- Account Type Selection Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full mb-12">
        <!-- Independent Artist Card -->
        <button
            onclick={() => selectType("artist")}
            class="group relative flex flex-col text-left p-6 rounded-xl bg-surface-dark border-2 {selectedType ===
            'artist'
                ? 'border-primary ring-2 ring-primary/20'
                : 'border-transparent hover:border-primary/50'} transition-all duration-300 focus:outline-none h-full"
        >
            {#if selectedType === "artist"}
                <div class="absolute top-4 right-4 text-primary">
                    <span class="material-symbols-outlined fill-1"
                        >check_circle</span
                    >
                </div>
            {/if}
            <div
                class="size-14 rounded-lg {selectedType === 'artist'
                    ? 'bg-primary text-surface-darker'
                    : 'bg-primary/10 text-primary'} flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-surface-darker transition-colors duration-300"
            >
                <span class="material-symbols-outlined text-3xl"
                    >mic_external_on</span
                >
            </div>
            <h3 class="text-white text-xl font-bold mb-3">
                Independent Artist
            </h3>
            <p
                class="text-text-secondary text-sm leading-relaxed mb-8 flex-grow"
            >
                For solo creators and independent bands managing their own
                rights and revenue directly.
            </p>
            <div
                class="mt-auto flex items-center text-primary font-bold text-sm"
            >
                {selectedType === "artist" ? "Selected" : "Select this option"}
                <span class="material-symbols-outlined ml-2 text-sm"
                    >{selectedType === "artist"
                        ? "task_alt"
                        : "arrow_forward"}</span
                >
            </div>
        </button>

        <!-- Record Label Card -->
        <button
            onclick={() => selectType("label")}
            class="group relative flex flex-col text-left p-6 rounded-xl bg-surface-dark border-2 {selectedType ===
            'label'
                ? 'border-primary ring-2 ring-primary/20'
                : 'border-transparent hover:border-primary/50'} transition-all duration-300 focus:outline-none h-full"
        >
            {#if selectedType === "label"}
                <div class="absolute top-4 right-4 text-primary">
                    <span class="material-symbols-outlined fill-1"
                        >check_circle</span
                    >
                </div>
            {/if}
            <div
                class="size-14 rounded-lg {selectedType === 'label'
                    ? 'bg-primary text-surface-darker'
                    : 'bg-primary/10 text-primary'} flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-surface-darker transition-colors duration-300"
            >
                <span class="material-symbols-outlined text-3xl">album</span>
            </div>
            <h3 class="text-white text-xl font-bold mb-3">
                Record Label / Publisher
            </h3>
            <p
                class="text-text-secondary text-sm leading-relaxed mb-8 flex-grow"
            >
                For entities managing catalogs for multiple artists,
                songwriters, and sub-publishers.
            </p>
            <div
                class="mt-auto flex items-center text-primary font-bold text-sm"
            >
                {selectedType === "label" ? "Selected" : "Select this option"}
                <span class="material-symbols-outlined ml-2 text-sm"
                    >{selectedType === "label"
                        ? "task_alt"
                        : "arrow_forward"}</span
                >
            </div>
        </button>

        <!-- PRO / CMO Card -->
        <button
            onclick={() => selectType("pro")}
            class="group relative flex flex-col text-left p-6 rounded-xl bg-surface-dark border-2 {selectedType ===
            'pro'
                ? 'border-primary ring-2 ring-primary/20'
                : 'border-transparent hover:border-primary/50'} transition-all duration-300 focus:outline-none h-full"
        >
            {#if selectedType === "pro"}
                <div class="absolute top-4 right-4 text-primary">
                    <span class="material-symbols-outlined fill-1"
                        >check_circle</span
                    >
                </div>
            {/if}
            <div
                class="size-14 rounded-lg {selectedType === 'pro'
                    ? 'bg-primary text-surface-darker'
                    : 'bg-primary/10 text-primary'} flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-surface-darker transition-colors duration-300"
            >
                <span class="material-symbols-outlined text-3xl"
                    >account_balance</span
                >
            </div>
            <h3 class="text-white text-xl font-bold mb-3">PRO / CMO</h3>
            <p
                class="text-text-secondary text-sm leading-relaxed mb-8 flex-grow"
            >
                For Collective Management Organizations and Performance Rights
                societies managing pan-African rights.
            </p>
            <div
                class="mt-auto flex items-center text-primary font-bold text-sm"
            >
                {selectedType === "pro" ? "Selected" : "Select this option"}
                <span class="material-symbols-outlined ml-2 text-sm"
                    >{selectedType === "pro"
                        ? "task_alt"
                        : "arrow_forward"}</span
                >
            </div>
        </button>
    </div>

    <!-- Action Footer -->
    <div class="flex flex-col items-center gap-6 w-full max-w-xs">
        <button
            onclick={handleContinue}
            class="btn-primary w-full py-4 rounded-xl text-lg shadow-lg shadow-primary/25"
        >
            Continue to Step 2
        </button>
        <button
            class="text-text-secondary hover:text-primary text-sm font-medium transition-colors flex items-center gap-1"
        >
            <span class="material-symbols-outlined text-base">help</span>
            Not sure which one to choose?
        </button>
    </div>
</div>
