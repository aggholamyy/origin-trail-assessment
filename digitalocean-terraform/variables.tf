variable "region_names" {
  description = "Regions of Digital Ocean Availability Zones"
  type        = list(string)
  default     = [
    "nyc1",
    "sgp1",
    "lon1",
    "nyc3",
    "ams3",
    "fra1",
    "tor1",
    "blr1",
    "sfo3"
    ]
}