<script lang="ts">
    let email = $state("");
    let password = $state("");
    let name = $state("");
</script>

<svelte:head>
    <title>Register | RoyaltyTrack</title>
</svelte:head>

<div class="flex flex-col gap-6">
    <div class="text-center">
        <h2 class="text-2xl font-bold">Create your account</h2>
        <p class="text-text-secondary text-sm">
            Start tracking your royalties today
        </p>
    </div>

    <form class="flex flex-col gap-4">
        <div class="flex flex-col gap-1.5">
            <label
                for="name"
                class="text-xs font-bold uppercase tracking-wider text-text-secondary"
                >Full Name / Artist Name</label
            >
            <input
                id="name"
                type="text"
                placeholder="Davey Jones"
                class="input"
                bind:value={name}
            />
        </div>

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
            <label
                for="password"
                class="text-xs font-bold uppercase tracking-wider text-text-secondary"
                >Password</label
            >
            <input
                id="password"
                type="password"
                placeholder="••••••••"
                class="input"
                bind:value={password}
            />
            <p class="text-[10px] text-text-muted">
                Must be at least 8 characters
            </p>
        </div>

        <button type="submit" class="btn-primary w-full mt-2">
            Get Started
        </button>
    </form>

    <p class="text-[10px] text-text-muted text-center px-4">
        By signing up, you agree to our
        <a href="/privacy" class="underline">Privacy Policy</a> and
        <a href="/terms" class="underline">Terms of Service</a>.
    </p>

    <p
        class="text-center text-sm text-text-secondary border-t border-border-dark pt-6"
    >
        Already have an account?
        <a href="/login" class="text-primary font-bold hover:underline"
            >Sign in</a
        >
    </p>
</div>
