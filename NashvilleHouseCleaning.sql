CREATE TABLE NashvilleHousing (
    UniqueID INT PRIMARY KEY,
    ParcelID VARCHAR(255),
    LandUse VARCHAR(255),
    PropertyAddress VARCHAR(255),
    SaleDate VARCHAR(255),
    SalePrice DECIMAL(18, 2),
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(10),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage DECIMAL(10, 2),
    TaxDistrict INT,
    LandValue DECIMAL(18, 2),
    BuildingValue DECIMAL(18, 2),
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);

SELECT * FROM nashvillehousing;
DROP TABLE nashvillehousing;