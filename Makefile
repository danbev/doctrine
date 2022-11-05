osi.wasm: data/licenses/osi.rego | build_dir
	opa build -t wasm -e osi_policy/is_osi $<
	@tar -xf bundle.tar.gz /policy.wasm >/dev/null 2>&1
	@mv policy.wasm build/$@
	@${RM} bundle.tar.gz

define opa_test
	opa test $^ tests/ -r $1 -v
endef

test-osi: data/licenses/osi.rego data/licenses/not_osi.rego
	@$(call opa_test,test_*_osi*)

test-network: data/licenses/network_copyleft.rego
	@$(call opa_test,test_*_network*)

test-permissive: data/licenses/permissive.rego
	@$(call opa_test,test_*_permissive*)

test: test-osi test-network test-permissive

.PHONY: build_dir
build_dir:
	@mkdir -p build

.PHONY: clean
clean:
	@${RM} -rf build
