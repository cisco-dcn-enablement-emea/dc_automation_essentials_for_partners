import logging
import os

from cobra.mit.access import MoDirectory
from cobra.mit.session import LoginSession
from cobra.mit.request import ConfigRequest
from cobra.mit.request import *
from cobra.modelimpl.config.exportp import ExportP

# Credentials, complete with the required information
apic_url = "https://" + os.getenv('APIC_HOST')
apic_user = os.getenv('APIC_USERNAME')
apic_pwd = os.getenv('APIC_PASSWORD')

# Set logging
rootLogger = logging.getLogger()
rootLogger.setLevel(logging.DEBUG)

# Logging into APIC
session = LoginSession(apic_url, apic_user, apic_pwd)
moDir = MoDirectory(session)
moDir.login()

logging.debug('Logging into APIC Successful')


# Creating the MO of the One time snapshot
moExport = ExportP(parentMoOrDn="uni/fabric",
                   name="backup_before_pipeline", snapshot="true", adminSt="triggered")

# Commit the MO
logging.debug("Trying to push configExportP")
cfgRequest = ConfigRequest()
cfgRequest.addMo(moExport)
moDir.commit(cfgRequest)
logging.debug("Snapshot triggered")
