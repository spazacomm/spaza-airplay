<script lang="ts">
    let email = $state("");
    let password = $state("");
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

    <form class="flex flex-col gap-4">
        <div class="flex flex-col gap-1.5">
            <label
                for="email"
                class="text-xs font-bold uppercase tracking-wider text-text-secondary"
                >Email Address</label
            >
            <input
                id="email"
                type="email"
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
                type="password"
                placeholder="••••••••"
                class="input"
                bind:value={password}
            />
        </div>

        <button type="submit" class="btn-primary w-full mt-2"> Sign In </button>
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
