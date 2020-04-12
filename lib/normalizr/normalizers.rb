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
    if String === value
      value.gsub(/[[:cntrl:]&&[^[:space:]]]/, '')
    else
      value
    end
  end

  add :phone do |value|
    if String === value
      value = value.gsub(/[^0-9]+/, '')
      value unless value.empty?
    else
      value
    end
  end

  add :squish do |value|
    if String === value
      value.strip.gsub(/\s+/, ' ')
    else
      value
    end
  end

  add :whitespace do |value|
    if String === value
      value.gsub(/[^\S\n]+/, ' ').gsub(/\s?\n\s?/, "\n").strip
    else
      value
    end
  end

  add :default do |value|
    Normalizr.normalize(value)
  end

  [:capitalize, :downcase, :parameterize, :strip, :upcase].each do |name|
    next unless String.method_defined?(name)

    add name do |value|
      if String === value
        value.send(:"#{name}")
      else
        value
      end
    end
  end
end
