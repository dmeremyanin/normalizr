class Author < ActiveRecord::Base
  normalize :name
  normalize :nickname,     with: :squish
  normalize :first_name,   with: :strip
  normalize :last_name,    with: :blank
  normalize :phone_number, with: :phone
  normalize :biography,    with: :whitespace
  normalize :bibliography, with: :control_chars
  normalize :slug,         with: :parameterize
end
