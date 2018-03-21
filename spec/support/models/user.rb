class User < Person
  normalize_attribute :firstname

  normalize :lastname, if: :should_normalize_lastname?
  normalize :maidenname, if: :should_normalize_maidenname_positive?, unless: :should_normalize_maidenname_negative?
  normalize :favouritebook, if: proc { true }

  def should_normalize_lastname?
    true
  end

  def should_normalize_maidenname_positive?
    true
  end

  def should_normalize_maidenname_negative?
    false
  end
end
