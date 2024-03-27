def test_sleep
  sleep 1
end

def test_busy_sleep
  start = Time.now
  while Time.now < start + 1
    # nothing
  end
end

test_sleep
test_busy_sleep
