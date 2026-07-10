# shellcheck shell=bash
# shellcheck disable=SC2034  # every variable here is read by the main script
#
# English — interface strings for keep-ssh-agent-alive.
#
# To add a new language: copy this file to <code>.sh (for example fr.sh),
# translate the values, keep the variable names. The new language shows up
# in Settings automatically — nothing else to change.
lang_name='English'

m_menu_open='Open a running session'
m_menu_new='Create a new session'
m_menu_stop='Stop sessions'
m_menu_settings='Settings'
m_menu_quit='Quit'

m_keys_main='enter: choose · esc: quit'
m_keys_back='enter: choose · esc: back'
m_keys_multi='space: select · enter: confirm · esc: back'

m_no_sessions='No sessions are running yet.'
m_preview='preview'
m_attached='attached'
m_idle='idle'
m_empty='(nothing running yet)'

m_name_q='Session name'
m_cmd_q='Command to run'
m_bad_name='Invalid name (no dots or colons, not empty).'
m_exists='already exists.'

m_stop_all='Stop all sessions'
m_confirm_1='Stop'
m_confirm_2='session(s)? The programs inside will be terminated. [y/N]:'

m_set_language='Language'
m_set_command='Default command'
m_set_hours='Maximum session age'
m_unlimited='unlimited'
m_hours_unit='hours'
m_hours_q='Maximum hours for a session, 0 = unlimited'
m_cmd_hint="type 'shell' for a plain shell"
m_saved='Saved.'
m_back='Back'

m_return='back to menu · keeps running'
