# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/*/(.+)\.rb$}) {'test'}
  watch(%r{^test/.+_test\.rb$})
  watch('test/helper.rb')  { "test" }
end
