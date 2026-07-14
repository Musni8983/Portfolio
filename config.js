// 
// SITE CONFIG - fill these in after creating your Supabase project
// Dashboard -> Project Settings -> API
//   SUPABASE_URL      = "Project URL"
//   SUPABASE_ANON_KEY = "anon public" key
//
// The anon key is SAFE to put here / commit to GitHub - it is
// designed to be public. It cannot read or write anything the
// database's Row Level Security policies don't explicitly allow.
// Your real secret (your admin password) is never in this file
// or anywhere in your code - it lives only in Supabase Auth.
// 

const SUPABASE_URL = "https://qgsxcwmluchyndfcvzye.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_m3YMOAGMSEeofaEtgsgdaA_mdI_Mn0P";

const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);