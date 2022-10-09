/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateConverted]
      ,[PropertySplitAddress]
      ,[PropertySplitCity]
      ,[OwnerSplitAddress]
      ,[OwnerSplitCity]
      ,[OwnerSplitState]
  FROM [sql_2nd_project].[dbo].[sql_2nd_project_housings]


--------------------------------------------------------------------

select * from sql_2nd_project.dbo.sql_2nd_project_housings


Select saleDateConverted, CONVERT(Date,SaleDate)
From sql_2nd_project.dbo.sql_2nd_project_housings


Update sql_2nd_project_housings
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE sql_2nd_project_housings
Add SaleDateConverted Date;

Update sql_2nd_project_housings
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select * 
From  sql_2nd_project.dbo.sql_2nd_project_housings
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From sql_2nd_project.dbo.sql_2nd_project_housings a
JOIN sql_2nd_project.dbo.sql_2nd_project_housings b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
 set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From sql_2nd_project.dbo.sql_2nd_project_housings a
JOIN sql_2nd_project.dbo.sql_2nd_project_housings b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From sql_2nd_project.dbo.sql_2nd_project_housings
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From sql_2nd_project.dbo.sql_2nd_project_housings



ALTER TABLE sql_2nd_project_housings
Add PropertySplitAddress Nvarchar(255);

Update sql_2nd_project_housings
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE sql_2nd_project_housings
Add PropertySplitCity Nvarchar(255);

Update sql_2nd_project_housings
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


---------------------------------------------------------------------------------------------------------------

Select OwnerAddress
From sql_2nd_project.dbo.sql_2nd_project_housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From sql_2nd_project.dbo.sql_2nd_project_housing



ALTER TABLE sql_2nd_project_housing
Add OwnerSplitAddress Nvarchar(255);

Update sql_2nd_project_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE sql_2nd_project_housing
Add OwnerSplitCity Nvarchar(255);

Update sql_2nd_project_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE sql_2nd_project_housing
Add OwnerSplitState Nvarchar(255);

Update sql_2nd_project_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From sql_2nd_project.dbo.sql_2nd_project_housing

-------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From sql_2nd_project.dbo.sql_2nd_project_housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From sql_2nd_project.dbo.sql_2nd_project_housing


Update sql_2nd_project_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
--------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From sql_2nd_project.dbo.sql_2nd_project_housings
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From sql_2nd_project.dbo.sql_2nd_project_housings

----------------------------------------------------------------------------------------------

Select *
From sql_2nd_project.dbo.sql_2nd_project_housings


ALTER TABLE sql_2nd_project.dbo.sql_2nd_project_housings
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate