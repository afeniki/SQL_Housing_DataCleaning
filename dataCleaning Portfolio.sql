--DATA CLEAINING WITH SQL

SELECT *
FROM housing

--1.) Covert the datetime format in the SaleDate column to just date
AlTER TABLE housing
ADD ConvertedSaleDate Date

UPDATE housing
SET ConvertedSaleDate = CONVERT(Date, SaleDate)

---------------------------------------------------------------------------------------------------------------
--2.) Checking for null values
SELECT *
FROM housing
WHERE PropertyAddress IS NULL

--If two rows have the same parcelid, set their address to be the same
SELECT data1.ParcelID, data1.PropertyAddress, data2.ParcelID, data2.PropertyAddress, ISNULL(data1.PropertyAddress, data2.PropertyAddress)
FROM housing as data1
JOIN housing as data2
	ON data1.ParcelID = data2.ParcelID
	AND data1.UniqueID <> data2.UniqueID
WHERE data1.PropertyAddress IS NULL


--input this into the PropertyAddress Column
UPDATE data1
SET PropertyAddress = ISNULL(data1.PropertyAddress, data2.PropertyAddress)
FROM housing as data1
JOIN housing as data2
	ON data1.ParcelID = data2.ParcelID
	AND data1.UniqueID <> data2.UniqueID
WHERE data1.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------
--2b)Split the data in the Property Address Column

--Breaking the address into address, city and state

SELECT HousePropertyAddress, HousePropertyCity
FROM housing

SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
  SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM housing;

ALTER TABLE housing
ADD HousePropertyAddress varchar(255)

UPDATE housing
SET HousePropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE housing
ADD HousePropertyCity varchar(255)

UPDATE housing
SET HousePropertyCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--------------------------------------------------------------------------------------------------
--3)Split the data in the Owner Address Column
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
FROM housing

ALTER TABLE housing
ADD OwnerPropertyAddress varchar(255)

UPDATE housing
SET OwnerPropertyAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE housing
ADD OwnerPropertyCity varchar(255)

UPDATE housing
SET OwnerPropertyCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE housing
ADD OwnerPropertyState varchar(255)

UPDATE housing
SET OwnerPropertyState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--------------------------------------------------------------------------------------------------
--3)Make the data consistent in the SoldAsVacant column
--N = No and Y = Yes
SELECT *
FROM housing


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM housing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant

SELECT
	CASE 
		WHEN SoldAsVacant = 'N' THEN 'NO'
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		ELSE SoldAsVacant
		END
FROM housing

UPDATE housing
SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'N' THEN 'NO'
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		ELSE SoldAsVacant
		END

--------------------------------------------------------------------------------------------------
--Getting Rid of Duplicates Using CTE-------------------------------------------
--1.) Identifying Duplicate Rows:
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	      PropertyAddress,
		  SalePrice,
		  SaleDate,
		  LegalReference
		  ORDER BY
			UniqueID
			) row_num
FROM housing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

---------------------------
--Deleting the duplicate row

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	      PropertyAddress,
		  SalePrice,
		  SaleDate,
		  LegalReference
		  ORDER BY
			UniqueID
			) row_num
FROM housing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


---------------------------------------------------------------------------------------------------
--4). Removing Unused Columns
ALTER TABLE housing
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE housing
DROP COLUMN SaleDate


SELECt *
FROM housing
