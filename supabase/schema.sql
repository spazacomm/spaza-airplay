-- Music Royalty Management Platform Schema
-- Generated 2026

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable PostGIS for location-based features (if needed for sources)
-- CREATE EXTENSION IF NOT EXISTS "postgis"; 

-----------------------------------------------------------------------------
-- 1. ENUMS & CONFIGURABLE TYPES
-- Comprehensive lists for African context and general royalty management.
-----------------------------------------------------------------------------

-- User Roles within the platform
CREATE TYPE user_role AS ENUM (
    'admin',            -- System Administrator
    'cmo_admin',        -- CMO Representative (e.g., MCSK Admin)
    'label_manager',    -- Record Label Manager
    'artist',           -- Registered Artist (Member of a PRO)
    'uploader',         -- Basic user authorized to upload content
    'analyst'           -- Read-only access for reports
);

-- Types of Organizations
CREATE TYPE organization_type AS ENUM (
    'CMO',              -- Collective Management Organization (e.g., MCSK)
    'PRO',              -- Performing Rights Organization
    'Label',            -- Record Label (e.g., Sony Music Africa)
    'Publisher',        -- Music Publisher
    'Broadcaster',      -- TV or Radio Station Owner
    'Venue',            -- Club, Hotel, Restaurant
    'Transport_Sacco',  -- Matatu SACCOs (transport associations)
    'Aggregator'        -- Digital Distributor
);

-- Rights Holder Types
-- Expanded based on UPRS definitions to include neighboring rights
CREATE TYPE rights_holder_type AS ENUM (
    'writer',           -- Songwriter / Composer / Lyricist (Economic Moral Rights)
    'publisher',        -- Music Publisher (Administers Economic Rights)
    'label',            -- Record Label (Master Rights Owner)
    'performer',        -- Featured Artist / Session Musician (Neighboring Rights)
    'producer',         -- Music Producer (Neighboring Rights)
    'arranger'          -- Musical Arranger
);

-- Ingestion Types
-- How the audio enters the system
CREATE TYPE ingestion_type AS ENUM (
    'iot_device',       -- Dedicated hardware (OLAF Box)
    'web_stream',       -- Internet Radio (Icecast/Shoutcast), YouTube Live
    'digital_dsp',      -- Official APIs (Spotify, Apple Music)
    'broadcast',        -- Satellite / Terrestrial FM / DVB-T (via Tuner hardware)
    'file_upload'       -- Manual batch upload
);

-- Work Roles (Composition)
CREATE TYPE work_role AS ENUM (
    'composer',
    'lyricist',
    'arranger',
    'publisher',
    'sub_publisher',
    'translator'
);

-- Recording Roles (Master)
CREATE TYPE recording_role AS ENUM (
    'performer',
    'producer',
    'featured_artist',
    'background_vocalist',
    'label',
    'distributor',
    'licensee'
);

-- Audio Source Types (Logic Types)
CREATE TYPE source_type AS ENUM (
    'commercial_radio',
    'community_radio',
    'public_broadcaster',
    'tv_station',
    'club',
    'hotel',
    'restaurant',
    'shop_retail',
    'matatu',
    'aircraft',
    'digital_service'
);

-- Source Status
CREATE TYPE source_status AS ENUM ('active', 'inactive', 'maintenance', 'offline');

-- African CMOs (Can be expanded)
-- Covers East, West, South, and Central Africa major players
CREATE TYPE cmo_name AS ENUM (
    -- Kenya
    'MCSK',     -- Music Copyright Society of Kenya (Composers/Authors)
    'KAMP',     -- Kenya Association of Music Producers (Master Rights)
    'PRISK',    -- Performers Rights Society of Kenya
    
    -- Uganda
    'UPRS',     -- Uganda Performing Right Society
    
    -- Tanzania
    'COSOTA',   -- Copyright Society of Tanzania
    
    -- Ghana
    'GHAMRO',   -- Ghana Music Rights Organisation
    
    -- Nigeria
    'COSON',    -- Copyright Society of Nigeria
    'MCSN',     -- Musical Copyright Society Nigeria
    
    -- South Africa
    'SAMRO',    -- Southern African Music Rights Organisation
    'CAPASSO',  -- Composers, Authors and Publishers Association (Mechanicals)
    'SAMPRA',   -- South African Music Performance Rights Association
    
    -- Rwanda
    'RSA',      -- Rwanda Society of Authors
    
    -- DRC
    'SOCODA',   -- Société Congolaise des Droits d'Auteurs et des Voisins
    
    -- Generic/Other
    'OTHER'
);

-- Royalty Calculation Methods
CREATE TYPE calculation_method AS ENUM (
    'per_play',                 -- Fixed amount per detected play (e.g., 5 KES per play)
    'scientific_distribution',  -- Pro-rata share of pool based on total detected plays
    'general_distribution',     -- Flat distribution for undetected/long-tail works
    'percentage_revenue',       -- % of ad revenue or venue license fee
    'flat_fee',                 -- Fixed monthly/annual fee (e.g., Gyms)
    'duration_based'            -- Rate based on seconds played
);

-- Fingerprint Processing Status
CREATE TYPE processing_status AS ENUM ('pending', 'processed', 'failed', 'archived');

-- Alert Trigger Events
CREATE TYPE alert_trigger AS ENUM (
    'song_detected',            -- When a specific song is played
    'threshold_reached',        -- When play count > X
    'new_royalty_statement',    -- Notification of payment
    'system_offline',           -- Source went down
    'unidentified_high_play'    -- High frequency play of unknown fingerprint
);

-----------------------------------------------------------------------------
-- 2. CORE TABLES
-----------------------------------------------------------------------------

-- ORGANIZATIONS
-- Represents the legal entities participating in the ecosystem.
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type organization_type NOT NULL,
    country TEXT,                       -- e.g., 'Kenya'
    contact_email TEXT,
    contact_phone TEXT,
    metadata JSONB DEFAULT '{}',        -- Store membership rules, tax IDs, etc.
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- PROFILES
-- Users of the platform. Extends the auth system (e.g. Supabase Auth).
CREATE TABLE profiles (
    id UUID PRIMARY KEY,                -- References auth.users.id if using Supabase
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    role user_role NOT NULL DEFAULT 'artist',
    
    -- Nullable because indie artists might not belong to a label organization
    organization_id UUID REFERENCES organizations(id) ON DELETE SET NULL,
    
    -- User Preferences (Platform Config)
    -- Stores UI settings, Localization, and Notification defaults
    -- Default structure ensures ready-to-use values
    preferences JSONB DEFAULT '{
        "theme": "system",
        "language": "en",
        "timezone": "Africa/Nairobi",
        "currency_display": "KES",
        "dashboard_layout": "comfortable",
        "notifications": {
            "email_digest": true,
            "push_alerts": true,
            "sms_critical": false
        }
    }',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-----------------------------------------------------------------------------
-- 3. CATALOG MANAGEMENT
-- Distinction between Works (Composition) and Recordings (Master).
-----------------------------------------------------------------------------

-- WORKS (The Composition)
-- Represents the intellectual property: Lyrics & Melody.
CREATE TABLE works (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    
    -- ISWC: International Standard Musical Work Code (Unique ID for composition)
    -- Format: T-123.456.789-C
    iswc TEXT UNIQUE, 
    
    -- Contributors snapshot (simple JSON view, detailed rights in work_rights)
    -- e.g., [{"name": "Sauti Sol", "role": "Composer"}]
    contributors JSONB DEFAULT '[]',
    
    metadata JSONB DEFAULT '{}',        -- Genre, Mood, Tempo (BPM)
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RECORDINGS (The Master)
-- A specific audio recording of a Work.
CREATE TABLE recordings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID REFERENCES works(id) ON DELETE CASCADE, -- Link to composition
    
    title TEXT NOT NULL,                -- e.g., "Sitya Loss (Radio Edit)"
    version TEXT,                       -- e.g., "Radio Edit", "Live", "Remix"
    
    -- ISRC: International Standard Recording Code (Unique ID for master)
    -- Format: CC-XXX-YY-NNNNN
    isrc TEXT UNIQUE,
    
    duration_seconds INTEGER,           -- Length of track
    release_date DATE,
    
    -- OLAF LINKAGE
    -- This ID corresponds to the hash stored in LMDB.
    -- OLAF doesn't use UUIDs natively, it uses Jenkins Hashes or Integers.
    -- Storing as TEXT to be flexible.
    fingerprint_id TEXT UNIQUE, 
    
    metadata JSONB DEFAULT '{}',        -- Label info, P-Line, C-Line
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RIGHTS HOLDERS (The Entities)
-- People or companies who get paid.
CREATE TABLE rights_holders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,                 -- Real name or Stage name
    
    -- IPI: Interested Party Information (Unique ID for rights holders)
    ipi_number TEXT UNIQUE,
    
    type rights_holder_type NOT NULL,
    
    -- Bank/Payment Details encrypted or tokenized ref
    payment_info JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- WORK RIGHTS (Publishing Splits)
-- Who owns the composition?
CREATE TABLE work_rights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id UUID REFERENCES works(id) ON DELETE CASCADE,
    rights_holder_id UUID REFERENCES rights_holders(id) ON DELETE CASCADE,
    
    role work_role NOT NULL, 
    share_percentage DECIMAL(5,2) NOT NULL CHECK (share_percentage <= 100),
    
    territory TEXT DEFAULT 'WORLDWIDE', -- e.g. "KE" for Kenya specific rights
    
    UNIQUE(work_id, rights_holder_id, role, territory)
);

-- RECORDING RIGHTS (Master Splits)
-- Who owns the master recording?
CREATE TABLE recording_rights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recording_id UUID REFERENCES recordings(id) ON DELETE CASCADE,
    rights_holder_id UUID REFERENCES rights_holders(id) ON DELETE CASCADE,
    
    role recording_role NOT NULL DEFAULT 'label',
    share_percentage DECIMAL(5,2) NOT NULL CHECK (share_percentage <= 100),
    
    territory TEXT DEFAULT 'WORLDWIDE',
    
    UNIQUE(recording_id, rights_holder_id, role, territory)
);

-----------------------------------------------------------------------------
-- 4. MONITORING SOURCES
-- Where usage data comes from.
-----------------------------------------------------------------------------

CREATE TABLE sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,                 -- e.g., "Classic 105", "Club 1824"
    type source_type NOT NULL,          -- The 'Business' type (e.g. Club, Matatu)
    ingestion_type ingestion_type NOT NULL DEFAULT 'iot_device', -- The 'Technical' type
    
    -- Location / Geography
    country TEXT NOT NULL,              -- ISO Code ideally, e.g. 'KE'
    region TEXT,                        -- e.g., 'Nairobi'
    city TEXT,
    
    -- Config for the ingestion engine
    -- e.g. { "stream_url": "http://...", "sample_rate": 44100 }
    stream_url TEXT,
    config JSONB DEFAULT '{}',
    
    -- IoT Specifics
    device_id TEXT UNIQUE,              -- Hardware ID for OLAF boxes
    gps_coordinates POINT,              -- Lat/Long for mapping
    
    status source_status DEFAULT 'active',
    last_heartbeat TIMESTAMPTZ,         -- Monitoring uptime
    
    organization_id UUID REFERENCES organizations(id) -- If source is owned by a specific org
);

-----------------------------------------------------------------------------
-- 5. LOGS & FINGERPRINTS
-- The massive data tables.
-----------------------------------------------------------------------------

-- PLAY LOGS (The "Hits")
-- Records discrete identification events.
CREATE TABLE play_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    source_id UUID REFERENCES sources(id) ON DELETE CASCADE,
    recording_id UUID REFERENCES recordings(id), -- Nullable if unidentified but logged
    
    timestamp_start TIMESTAMPTZ NOT NULL, -- When the song started playing
    duration_played_seconds DECIMAL(10,2), -- How long it played
    
    confidence_score DECIMAL(5,4),        -- 0.0 to 1.0 OLAF match confidence
    
    -- Audio Verification feature
    -- S3/GCS path to the specific recorded snippet for manual audit
    audio_snippet_path TEXT,
    
    -- Raw metadata from the match event (debug info)
    raw_match_metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_play_logs_source_time ON play_logs(source_id, timestamp_start);
CREATE INDEX idx_play_logs_recording ON play_logs(recording_id);

-- RAW FINGERPRINTS (The Archive)
-- Stores references to raw OLAF hash blobs for archival/re-processing.
-- Granularity: Flexible.
-- NOTE: For GCS/S3 storage, storing a single 'Day' blob is cost-effective (fewer API calls)
-- but 'Hour' blobs allow for faster partial retrieval/debugging.
-- Supported: 1 Hour (Standard), 24 Hours (Low Cost).
CREATE TABLE raw_fingerprints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    source_id UUID REFERENCES sources(id) ON DELETE CASCADE,
    
    timestamp_start TIMESTAMPTZ NOT NULL,
    timestamp_end TIMESTAMPTZ NOT NULL,
    
    -- Storage Strategy:
    -- 'fingerprint_data' can hold JSONB for small blocks, 
    -- 'storage_path' holds S3/GCS URI for large binary blobs (e.g. "gs://bucket/source_id/2023-10-27_full_day.mdb").
    fingerprint_data JSONB, 
    storage_path TEXT, 
    
    status processing_status DEFAULT 'processed',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT check_storage CHECK (fingerprint_data IS NOT NULL OR storage_path IS NOT NULL)
);
CREATE INDEX idx_raw_fps_source_time ON raw_fingerprints(source_id, timestamp_start);

-----------------------------------------------------------------------------
-- 6. ROYALTY MANAGEMENT
-----------------------------------------------------------------------------

-- ROYALTY SOCIETIES (The CMOs)
CREATE TABLE royalty_societies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name cmo_name NOT NULL,             -- e.g. MCSK
    full_name TEXT,                     -- e.g. Music Copyright Society of Kenya
    country TEXT NOT NULL,
    currency TEXT DEFAULT 'KES',        -- Currency for distributions
    contact_info JSONB
);

-- RATE TABLES
-- Defines how much a play is worth based on context.
CREATE TABLE rate_tables (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    society_id UUID REFERENCES royalty_societies(id),
    
    -- Applicability criteria
    source_type source_type,            -- Null means all types
    
    -- The Logic
    calculation_method calculation_method NOT NULL,
    
    -- Values
    rate_amount DECIMAL(12, 4),         -- e.g. 5.00 (Fixed amount)
    revenue_percentage DECIMAL(5, 2),   -- e.g. 2.5% (Of revenue)
    
    effective_date DATE NOT NULL,
    expiry_date DATE,
    
    -- Complex Rules Engine
    -- e.g. { "min_play_duration": 30, "premium_time_multiplier": 1.5 }
    rules JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- STATEMENTS / DISTRIBUTIONS
-- Generated reports of money owed.
CREATE TABLE royalty_statements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rights_holder_id UUID REFERENCES rights_holders(id),
    society_id UUID REFERENCES royalty_societies(id),
    
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    
    total_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    status TEXT DEFAULT 'draft',        -- draft, approved, paid
    
    details_json JSONB,                 -- Breakdown of calculations
    
    generated_at TIMESTAMPTZ DEFAULT NOW()
);

-----------------------------------------------------------------------------
-- 7. REPORTS & ALERTS
-----------------------------------------------------------------------------

-- SCHEDULED REPORTS
CREATE TABLE scheduled_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,                 -- e.g., "Monthly KBC Logs"
    
    report_type TEXT NOT NULL,          -- e.g., 'play_log_export', 'royalty_summary'
    
    -- Cron syntax for scheduling
    schedule_cron TEXT NOT NULL,        -- e.g. "0 0 1 * *" (Monthly)
    
    recipients TEXT[],                  -- Array of email addresses
    email_subject_template TEXT,
    
    -- Config for the report generator
    -- e.g. { "source_ids": ["..."], "format": "pdf" }
    config JSONB DEFAULT '{}',
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ALERTS
-- Real-time notifications for events.
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    
    name TEXT NOT NULL,                 -- e.g. "My Song Radio Alert"
    trigger_event alert_trigger NOT NULL,
    
    -- Conditions
    -- e.g. { "recording_id": "...", "source_id": "..." }
    conditions JSONB DEFAULT '{}',
    
    channels TEXT[] DEFAULT ARRAY['email'], -- ['email', 'sms', 'push']
    
    is_active BOOLEAN DEFAULT true,
    last_triggered_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- COMMENTARY
COMMENT ON TABLE works IS 'Musical compositions (lyrics/melody). Unique by ISWC.';
COMMENT ON TABLE recordings IS 'Master recordings of a Work. Unique by ISRC. Linked to OLAF fingerprints.';
COMMENT ON TABLE play_logs IS 'Individual detection events of a song playing on a source.';
COMMENT ON TABLE raw_fingerprints IS 'Archival blocks of raw acoustic fingerprints (1-hour chunks) for debugging or re-scanning.';
COMMENT ON COLUMN sources.device_id IS 'Unique hardware identifier for deployed OLAF monitoring units.';