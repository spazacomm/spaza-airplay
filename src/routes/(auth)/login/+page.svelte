<script lang="ts">
    import { enhance } from "$app/forms";
    let { form } = $props();

    let email = $state("");
    let password = $state("");
    let loading = $state(false);
</script>

<svelte:head>
    <title>Login | RoyaltyTrack</title>
</svelte:head>

<div class="flex flex-col gap-6">
    <div class="text-center">
        <h2 class="text-2xl font-bold">Welcome back</h2>
        <p class="text-text-secondary text-sm">
            Enter your credentials to access your portal
        </p>
    </div>

    {#if form?.message}
        <div
            class="bg-red-500/10 border border-red-500/20 text-red-500 text-xs p-3 rounded-md text-center font-medium"
        >
            {form.message}
        </div>
    {/if}

    <form
        method="POST"
        use:enhance={() => {
            loading = true;
            return async ({ update }) => {
                loading = false;
                await update();
            };
        }}
        class="flex flex-col gap-4"
    >
        <div class="flex flex-col gap-1.5">
            <label
                for="email"
                class="text-xs font-bold uppercase tracking-wider text-text-secondary"
                >Email Address</label
            >
            <input
                id="email"
                name="email"
                type="email"
                required
                placeholder="artist@example.com"
                class="input"
                bind:value={email}
            />
        </div>

        <div class="flex flex-col gap-1.5">
            <div class="flex justify-between items-center">
                <label
                    for="password"
                    class="text-xs font-bold uppercase tracking-wider text-text-secondary"
                    >Password</label
                >
                <a
                    href="/forgot-password"
                    class="text-xs text-primary hover:underline"
                    >Forgot password?</a
                >
            </div>
            <input
                id="password"
                name="password"
                type="password"
                required
                placeholder="••••••••"
                class="input"
                bind:value={password}
            />
        </div>

        <button
            type="submit"
            class="btn-primary w-full mt-2"
            disabled={loading}
        >
            {loading ? "Signing In..." : "Sign In"}
        </button>
    </form>

    <div class="relative">
        <div class="absolute inset-0 flex items-center">
            <span class="w-full border-t border-border-dark"></span>
        </div>
        <div class="relative flex justify-center text-xs uppercase">
            <span class="bg-surface-darker px-2 text-text-muted"
                >Or continue with</span
            >
        </div>
    </div>

    <div class="grid grid-cols-2 gap-4">
        <button class="btn-secondary py-2 text-sm"> Google </button>
        <button class="btn-secondary py-2 text-sm"> Spotify </button>
    </div>

    <p class="text-center text-sm text-text-secondary">
        Don't have an account?
        <a href="/register" class="text-primary font-bold hover:underline"
            >Create one</a
        >
    </p>
</div>
