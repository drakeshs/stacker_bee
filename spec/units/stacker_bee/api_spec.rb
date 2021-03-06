require "spec_helper"

describe StackerBee::API do
  subject { api }

  let(:api) { StackerBee::API.new(api_path: api_path) }
  let(:api_path) do
    File.join(File.dirname(__FILE__), '../../fixtures/simple.json')
  end

  its(:api_path) { should eq api_path }

  its(["list_virtual_machines"]) { should be_a Hash }
  its(["get_vm_password"])       { should be_a Hash }
  its(["getvmpassword"])         { should be_a Hash }
  its(["getVMPassword"])         { should be_a Hash }
  its(["getVmPassword"])         { should be_a Hash }
  its(["getWRONG"])              { should be_nil }

  it { should be_key "get_vm_password" }
  it { should be_key "getvmpassword" }
  it { should be_key "getVMPassword" }
  it { should be_key "getVmPassword" }
end
