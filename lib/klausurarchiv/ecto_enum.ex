import EctoEnum

defenum(TermTypeEnum, :term_type, [
  :summer_term,
  :winter_term
])

defenum(UserRole, :user_role, [
  :user,
  :admin
])

defenum(UserTokenTypeEnum, :user_token_type, [
  :password_reset,
  :account_confirmation
])
