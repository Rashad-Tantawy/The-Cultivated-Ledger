import 'package:supabase_flutter/supabase_flutter.dart';

/// Convenience accessor for the Supabase client throughout the app.
SupabaseClient get supabase => Supabase.instance.client;
