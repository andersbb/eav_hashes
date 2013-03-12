require 'spec_helper'

describe ActiveRecord::EavHashes do
  describe "key constraints" do
    context "when no key constraint model is specified" do
      it "should set options[:constraint_model] to nil by default" do
        options = Product.class_variable_get :@@tech_specs_hash_options
        options.should have_key :constraint_model
        options[:constraint_model].should be_nil
      end

      it "should allow arbitrary keys to be assigned, read, and persisted" do
        product = Product.create
        product.tech_specs['xyzzy'] = 'foo'
        product.save!
        product.reload.tech_specs['xyzzy'] = 'foo'
      end
    end

    context "when a key constraint model is specified" do
      let(:customer) { Customer.create }

      it "should store the model class name in options[:constraint_model]" do
        options = Customer.class_variable_get :@@address_hash_options
        options[:constraint_model].should == 'CustomerAddressKeyName'
      end

      it "should create an accessor for each key name in the constraint table" do
        customer.should respond_to :street
        customer.should respond_to :city
        customer.should respond_to :state
        customer.should respond_to :zip
        customer.should respond_to :street=
        customer.should respond_to :city=
        customer.should respond_to :state=
        customer.should respond_to :zip=
      end

      it "should allow hash values to be read and written using the accessors" do
        customer.zip = '90210'
        customer.zip.should == '90210'
      end

      it "should persist hash values assigned using the accessors" do
        customer.city = 'Beverly Hills'
        customer.save!
        customer.reload.city.should == 'Beverly Hills'
      end

      it "should allow the accessors to be mass-assigned and persisted" do
        customer2 = Customer.create(street: 'Sunset Boulevard')
        customer2.reload.street.should == 'Sunset Boulevard'
      end

      it "should allow hash assignments with the keys specified in the constraint table" do
        expect { customer.address['state'] = 'CA' }.to_not raise_error
        customer.address['state'].should == 'CA'
      end

      it "should raise ActiveRecord::EavHashes::IllegalKeyError when a key not in the constraint table is assigned" do
        expect { customer.address['xyzzy'] = 'foo' }.to raise_error ActiveRecord::EavHashes::IllegalKeyError
      end

      it "should raise ActiveRecord::EavHashes::IllegalKeyError when a key not in the constraint table is read" do
        expect { customer.address['xyzzy'] }.to raise_error ActiveRecord::EavHashes::IllegalKeyError
      end

      context "and a constraint column is specified" do
        it "should read key names from the specified column instead of from 'name'" do
          package = Package.create
          package.key_names.sort.should == %w(width height depth).sort
        end
      end
    end
  end
end