SELECT *
FROM PortfolioProject..NashvilleHousing



--Date format

SELECT SaleDateConverted, CONVERT(DATE,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)



ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)



--Populate property address data

SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT Nash.ParcelID, Nash.PropertyAddress, Hous.ParcelID, Hous.PropertyAddress, ISNULL(Nash.PropertyAddress,Hous.PropertyAddress) 
FROM PortfolioProject..NashvilleHousing Nash
JOIN PortfolioProject..NashvilleHousing Hous
	ON Nash.ParcelID = Hous.ParcelID AND Nash.[UniqueID ] <> Hous.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL

UPDATE Nash
SET PropertyAddress = ISNULL(Nash.PropertyAddress,Hous.PropertyAddress) 
FROM PortfolioProject..NashvilleHousing Nash
JOIN PortfolioProject..NashvilleHousing Hous
	ON Nash.ParcelID = Hous.ParcelID AND Nash.[UniqueID ] <> Hous.[UniqueID ]
WHERE Nash.PropertyAddress IS NULL



--Moving the Address to the different columns

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS PropertySplitAdress
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS PropertySplitCity
FROM PortfolioProject..NashvilleHousing 


ALTER TABLE NashvilleHousing
ADD PropertySplitAdress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

--Easier one 

SELECT *
FROM NashvilleHousing

SELECT OwnerAddress
FROM NashvilleHousing

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) AS OwnerSplitAddress
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) AS OwnerSplitCity
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) AS OwnerSplitState
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnersplitAddress NVARCHAR(255)
UPDATE NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)
UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT *
FROM NashvilleHousing



--Change Y and N to Yes and No in SoldASVacant

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing
GROUP BY SoldAsVacant

UPDATE NashvilleHousing
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = 'Y';

UPDATE NashvilleHousing
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N';

--OR

UPDATE NashvilleHousing
SET SoldAsVacant = 
					CASE
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END



-- Remove Dublicates

WITH RowNumDif AS
(
SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID, PropertyAddress, SaleDate, LegalReference ORDER BY UniqueID) row_num
FROM NashvilleHousing
)

DELETE
FROM RowNumDif
WHERE row_num > 1



--Delete Unused Colums

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

