DATA_FILES:=utils.rego
TFPLAN_JSON:=tfplan.json
CURRENT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
POLICY_DIR:="$(CURRENT_DIR)/policies"
POLICY_TYPES:=$$(find $(POLICY_DIR) -mindepth 1 -maxdepth 1 -type d | awk -F "/" '{print $$NF}')

.PHONY: opa

opa:

# Generate Report
	echo "#### OPA Compliance Report" > REPORT.md; \
	echo "|Category | Total | Pass | Fail | Comments|" >> REPORT.md; \
	echo "| --- | :--- | :--- | :--- | :--- |" >> REPORT.md; \
	echo "-------------------------------------"; >> REPORT.md; \
	FAILURES=0; \
	for TYPE in $(POLICY_TYPES); do \
		for FILE in $(DATA_FILES); do \
			cp $(POLICY_DIR)/$$FILE $(POLICY_DIR)/$$TYPE; \
			cp $(TFPLAN_JSON) $(POLICY_DIR)/$$TYPE; \
		done; \
		ls -ltr $(POLICY_DIR)/$$TYPE ; \
		/usr/local/bin/opa check --format json $(POLICY_DIR)/$$TYPE ; \
	done; \
	cat REPORT.md

