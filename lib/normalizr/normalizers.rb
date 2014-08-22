require 'set'

Normalizr.configure do
  default :strip, :blank

  add :blank do |value|
    value unless /\A[[:space:]]*\z/ === value
  end

  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].to_set

  add :boolean do |value|
    unless String === value && value.blank?
      TRUE_VALUES.include?(value)
    end
  end

  add :control_chars do |value|
    value.gsub!(/[[:cntrl:]&&[^[:space:]]]/, '') if String === value
    value
  end

  add :phone do |value|
    if String === value
      value.gsub!(/[^0-9]+/, '')
      value unless value.empty?
    else
      value
    end
  end

  add :squish do |value|
    if String === value
      value.strip!
      value.gsub!(/\s+/, ' ')
    end
    value
  end

  add :whitespace do |value|
    if String === value
      value.gsub!(/[^\S\n]+/, ' ')
      value.gsub!(/\s?\n\s?/, "\n")
      value.strip!
    end
    value
  end

  [:capitalize, :downcase, :strip, :upcase].each do |name|
    add name do |value|
      value.send(:"#{name}!") if String === value
      value
    end
  end
end
