-- Spaza Airplay Supabase Schema (v2)574-- Robust implementation for African Music Market

-- 1. Profiles (Enhanced User management)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    stage_name TEXT,
    legal_name TEXT,
    avatar_url TEXT,
    role TEXT DEFAULT 'artist' CHECK (role IN ('artist', 'manager', 'label', 'admin', 'pro_cmo')),
    plan TEXT DEFAULT 'free' CHECK (plan IN ('free', 'pro', 'label')),
    ipi_number TEXT, -- International identifier for songwriters
    ipn_number TEXT, -- International identifier for performers
    primary_territory TEXT, -- e.g., 'NG', 'ZA', 'KE'
    onboarding_step INTEGER DEFAULT 1,
    is_onboarded BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Notification Settings
CREATE TABLE IF NOT EXISTS public.notification_settings (
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
    new_play_detected BOOLEAN DEFAULT TRUE,
    royalty_milestone BOOLEAN DEFAULT TRUE,
    pro_variance_alert BOOLEAN DEFAULT FALSE,
    weekly_digest BOOLEAN DEFAULT TRUE,
    push_enabled BOOLEAN DEFAULT TRUE,
    email_enabled BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Security Logs (Tracking logins and sensitive changes)
CREATE TABLE IF NOT EXISTS public.security_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    action TEXT NOT NULL, -- 'login', 'password_change', '2fa_enable', etc.
    status TEXT DEFAULT 'success',
    ip_address TEXT,
    user_agent TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Payout Methods
CREATE TABLE IF NOT EXISTS public.payout_methods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- 'bank', 'mobile_money', 'paypal'
    provider TEXT, -- e.g., 'MTN', 'Kuda', 'Standard Bank'
    account_number TEXT,
    account_name TEXT,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Artists
CREATE TABLE IF NOT EXISTS public.artists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    bio TEXT,
    country TEXT NOT NULL,
    avatar_url TEXT,
    spotify_url TEXT,
    apple_music_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Tracks
CREATE TABLE IF NOT EXISTS public.tracks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    artist_id UUID REFERENCES public.artists(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    album TEXT,
    genre TEXT,
    isrc TEXT UNIQUE,
    cover_url TEXT,
    bpm INTEGER,
    musical_key TEXT,
    mood TEXT,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Live', 'Pending', 'Takedown', 'Processing')),
    release_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Broadcasters
CREATE TABLE IF NOT EXISTS public.broadcasters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT CHECK (type IN ('Radio', 'TV', 'Digital')),
    country TEXT NOT NULL,
    location TEXT,
    tier INTEGER DEFAULT 2 CHECK (tier IN (1, 2, 3)),
    base_rate DECIMAL(10, 2) DEFAULT 5.00,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Airplay Logs
CREATE TABLE IF NOT EXISTS public.airplay_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    track_id UUID REFERENCES public.tracks(id) ON DELETE CASCADE,
    broadcaster_id UUID REFERENCES public.broadcasters(id) ON DELETE CASCADE,
    played_at TIMESTAMPTZ NOT NULL,
    duration INTERVAL,
    royalty_estimated DECIMAL(10, 2),
    status TEXT DEFAULT 'Processed' CHECK (status IN ('Detected', 'Processed', 'Reconciled')),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. Earnings Summaries
CREATE TABLE IF NOT EXISTS public.earnings_summaries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    artist_id UUID REFERENCES public.artists(id) ON DELETE CASCADE,
    total_plays BIGINT DEFAULT 0,
    total_earnings DECIMAL(15, 2) DEFAULT 0.00,
    last_payout DATE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.security_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payout_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.artists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.broadcasters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.airplay_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.earnings_summaries ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view their own notification settings" ON public.notification_settings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own notification settings" ON public.notification_settings FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view their own security logs" ON public.security_logs FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own payout methods" ON public.payout_methods FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view their own artists" ON public.artists FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own artists" ON public.artists FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Tracks are visible to authorized users" ON public.tracks FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.artists WHERE artists.id = tracks.artist_id AND artists.user_id = auth.uid())
);

CREATE POLICY "Broadcasters are public" ON public.broadcasters FOR SELECT USING (true);

CREATE POLICY "Logs are visible to track owners" ON public.airplay_logs FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.tracks 
        JOIN public.artists ON tracks.artist_id = artists.id 
        WHERE tracks.id = airplay_logs.track_id AND artists.user_id = auth.uid()
    )
);

CREATE POLICY "Earnings visible to owners" ON public.earnings_summaries FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.artists WHERE artists.id = earnings_summaries.artist_id AND artists.user_id = auth.uid())
);

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  
  INSERT INTO public.notification_settings (user_id)
  VALUES (new.id);
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
