import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { User } from '@supabase/supabase-js';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      (async () => {
        setUser(session?.user ?? null);
        setLoading(false);
      })();
    });

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      setError(null);
      setLoading(true);

      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      setUser(data.user);
      return { success: true };
    } catch (err: any) {
      const errorMessage = err.message === 'Invalid login credentials'
        ? 'Email ou senha incorretos'
        : 'Erro ao fazer login. Tente novamente.';
      setError(errorMessage);
      return { success: false, error: errorMessage };
    } finally {
      setLoading(false);
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      setError(null);
      setLoading(true);

      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          emailRedirectTo: window.location.origin,
        }
      });

      if (error) throw error;

      if (!data.user) {
        throw new Error('Erro ao criar usuário');
      }

      // Supabase pode retornar o usuário mas ainda não ter confirmado o email
      // Se session existe, o usuário está autenticado
      if (data.session) {
        setUser(data.user);
        return { success: true, message: 'Conta criada com sucesso!' };
      } else {
        // Se não há session, pode ser que precise confirmar email
        return {
          success: true,
          message: 'Conta criada! Por favor, faça login com suas credenciais.',
          needsLogin: true
        };
      }
    } catch (err: any) {
      const errorMessage = err.message === 'User already registered'
        ? 'Este email já está cadastrado'
        : err.message || 'Erro ao criar conta. Tente novamente.';
      setError(errorMessage);
      return { success: false, error: errorMessage };
    } finally {
      setLoading(false);
    }
  };

  const signOut = async () => {
    try {
      setError(null);
      await supabase.auth.signOut();
      setUser(null);
    } catch (err: any) {
      setError(err.message);
    }
  };

  return {
    user,
    loading,
    error,
    signIn,
    signUp,
    signOut,
  };
}
