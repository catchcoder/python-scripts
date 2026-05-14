from zeroconf import Zeroconf, ServiceBrowser

class MyListener:
    def add_service(self, zeroconf, service_type, name):
        print(f"Service added: {name}")

    def remove_service(self, zeroconf, service_type, name):
        print(f"Service removed: {name}")

    def update_service(self, zeroconf, service_type, name):
        print(f"Service updated: {name}")

zeroconf = Zeroconf()
listener = MyListener()

# Browse ALL services
browser = ServiceBrowser(zeroconf, "_services._dns-sd._udp.local.", listener)

try:
    print("Browsing mDNS services… Press Ctrl+C to stop.")
    import time
    while True:
        time.sleep(0.1)
except KeyboardInterrupt:
    pass
finally:
    zeroconf.close()