<script lang="ts">
	import { page } from "$app/stores";

	let user = $derived($page.data.user);
	let profile = $derived(user?.profile);

	interface NavItem {
		label: string;
		href: string;
		icon: string;
		children?: NavItem[];
	}

	const navigation: NavItem[] = [
		{ label: "Dashboard", href: "/dashboard", icon: "dashboard" },
		{
			label: "Catalogue",
			href: "/catalogue",
			icon: "library_music",
			children: [
				{
					label: "Rights Holders",
					href: "/catalogue/rights-holders",
					icon: "groups",
				},
				{
					label: "Works",
					href: "/catalogue/works",
					icon: "music_note",
				},
				{
					label: "Recordings",
					href: "/catalogue/recordings",
					icon: "album",
				},
			],
		},
		{
			label: "Sources",
			href: "/sources",
			icon: "router",
		},
		{
			label: "Play Logs",
			href: "/play-logs",
			icon: "history",
		},
		// {
		// 	label: "Royalties",
		// 	href: "/royalties",
		// 	icon: "payments",
		// 	children: [
		// 		{
		// 			label: "Rates",
		// 			href: "/royalties/rates",
		// 			icon: "request_quote",
		// 		},
		// 		{
		// 			label: "Societies",
		// 			href: "/royalties/societies",
		// 			icon: "account_balance",
		// 		},
		// 		{
		// 			label: "Statements",
		// 			href: "/royalties/statements",
		// 			icon: "description",
		// 		},
		// 	],
		// },
		{
			label: "Reports & Alerts",
			href: "/reports",
			icon: "assessment",
			children: [
				{
					label: "Reports Gallery",
					href: "/reports/gallery",
					icon: "summarize",
				},
				{
					label: "Alert Rules",
					href: "/reports/alerts",
					icon: "notifications_active",
				},
			],
		},
		{
			label: "Settings",
			href: "/settings",
			icon: "settings",
			children: [
				{ label: "Users", href: "/settings/users", icon: "group" },
				{
					label: "Organization",
					href: "/settings/organization",
					icon: "business",
				},
				{
					label: "Preferences",
					href: "/settings/preferences",
					icon: "tune",
				},
				{
					label: "Audit Logs",
					href: "/settings/audit-logs",
					icon: "receipt_long",
				},
			],
		},
	];

	const bottomNav: NavItem[] = [
		{ label: "Help & Docs", href: "/help", icon: "help" },
	];

	function isActive(href: string): boolean {
		return (
			$page.url.pathname === href ||
			$page.url.pathname.startsWith(href + "/")
		);
	}

	let expandedSections = $state<Set<string>>(new Set());

	function toggleSection(label: string) {
		if (expandedSections.has(label)) {
			expandedSections.delete(label);
		} else {
			expandedSections.add(label);
		}
		expandedSections = new Set(expandedSections);
	}
</script>

<aside
	class="w-64 flex-shrink-0 border-r border-border-dark bg-white flex flex-col justify-between p-4 hidden md:flex"
>
	<div class="flex flex-col gap-6">
		<!-- Logo -->
		<div class="flex items-center gap-3 px-2">
			<img
				src="/logo-icon.png"
				alt="Spaza Airplay"
				class="h-14 w-auto object-contain"
			/>
			<div>
				<h1 class="font-bold text-lg tracking-tight">Spaza Airplay</h1>
				<p class="text-xs text-text-secondary">CMO Portal</p>
			</div>
		</div>

		<!-- Main Navigation -->
		<nav class="flex flex-col gap-1">
			{#each navigation as item}
				{#if item.children}
					<!-- Collapsible section -->
					<button
						class="nav-item w-full justify-between"
						class:nav-item-active={isActive(item.href)}
						onclick={() => toggleSection(item.label)}
					>
						<span class="flex items-center gap-3">
							<span class="material-symbols-outlined"
								>{item.icon}</span
							>
							<span class="text-sm font-medium">{item.label}</span
							>
						</span>
						<span
							class="material-symbols-outlined text-sm transition-transform"
							class:rotate-180={expandedSections.has(item.label)}
						>
							expand_more
						</span>
					</button>
					{#if expandedSections.has(item.label)}
						<div class="ml-6 flex flex-col gap-1 mt-1">
							{#each item.children as child}
								<a
									href={child.href}
									class="nav-item text-sm"
									class:nav-item-active={isActive(child.href)}
								>
									<span
										class="material-symbols-outlined text-lg"
										>{child.icon}</span
									>
									<span>{child.label}</span>
								</a>
							{/each}
						</div>
					{/if}
				{:else}
					<!-- Simple link -->
					<a
						href={item.href}
						class="nav-item"
						class:nav-item-active={isActive(item.href)}
					>
						<span class="material-symbols-outlined"
							>{item.icon}</span
						>
						<span class="text-sm font-medium">{item.label}</span>
					</a>
				{/if}
			{/each}
		</nav>
	</div>

	<!-- Bottom Navigation -->
	<div class="flex flex-col gap-1">
		{#each bottomNav as item}
			<a
				href={item.href}
				class="nav-item"
				class:nav-item-active={isActive(item.href)}
			>
				<span class="material-symbols-outlined">{item.icon}</span>
				<span class="text-sm font-medium">{item.label}</span>
			</a>
		{/each}

		<!-- User Profile -->
		<div class="flex items-center gap-3 mt-4 pt-4 border-t border-white/10">
			<div
				class="rounded-full size-10 border border-border-dark bg-background-dark flex items-center justify-center overflow-hidden"
			>
				{#if profile?.avatar_url}
					<img
						src={profile.avatar_url}
						alt={profile.full_name}
						class="w-full h-full object-cover"
					/>
				{:else}
					<span class="material-symbols-outlined text-text-secondary"
						>person</span
					>
				{/if}
			</div>
			<div class="flex-1 min-w-0">
				<p class="text-sm font-bold truncate">
					{profile?.full_name || "Anonymous"}
				</p>
				<p class="text-xs text-text-secondary truncate">
					{profile?.plan
						? profile.plan.charAt(0).toUpperCase() +
							profile.plan.slice(1)
						: "Standard"} Plan
				</p>
			</div>
			<form action="/api/logout" method="POST">
				<button
					type="submit"
					class="p-2 text-text-secondary hover:text-red-500 transition-colors"
					title="Sign Out"
				>
					<span class="material-symbols-outlined text-[20px]"
						>logout</span
					>
				</button>
			</form>
		</div>
	</div>
</aside>
