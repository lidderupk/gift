//
//  AlbumCollectionViewLayout.m
//  Memories
//
//  Created by Ruchi Varshney on 2/14/14.
//
//

#import "AlbumCollectionViewLayout.h"

@interface AlbumCollectionViewLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation AlbumCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.cellInsets = UIEdgeInsetsMake(25.0f, 25.0f, 25.0f, 25.0f);
    self.cellSize = CGSizeMake(220.0f, 220.f);
    self.interCellSpacing = 27.0f;
    self.numColumns = 3;
    //self.titleHeight = 30.0f;
}

#pragma mark - Properties

- (void)setCellInsets:(UIEdgeInsets)cellInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_cellInsets, cellInsets)) {
        return;
    }
    _cellInsets = cellInsets;
    [self invalidateLayout];
}

- (void)setCellSize:(CGSize)cellSize
{
    if (CGSizeEqualToSize(_cellSize, cellSize)) {
        return;
    }
    _cellSize = cellSize;
    [self invalidateLayout];
}

- (void)setInterCellSpacing:(CGFloat)interCellSpacing
{
    if (_interCellSpacing == interCellSpacing) {
        return;
    }
    _interCellSpacing = interCellSpacing;
    [self invalidateLayout];
}

- (void)setNumColumns:(NSInteger)numColumns
{
    if (_numColumns == numColumns) {
        return;
    }
    _numColumns = numColumns;
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) {
        return;
    }
    _titleHeight = titleHeight;
    [self invalidateLayout];
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *cellLayoutInfo = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *titleLayoutInfo = [[NSMutableDictionary alloc] init];

    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;

            if (indexPath.item == 0) {
                //UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"AlbumTitle" withIndexPath:indexPath];
                //titleAttributes.frame = [self frameForAlbumTitleAtIndexPath:indexPath];
                //titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }

    newLayoutInfo[@"AlbumCell"] = cellLayoutInfo;
    //newLayoutInfo[@"AlbumTitle"] = titleLayoutInfo;

    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numColumns;
    NSInteger column = indexPath.section % self.numColumns;

    CGFloat spacing = self.collectionView.bounds.size.width - self.cellInsets.left - self.cellInsets.right - (self.numColumns * self.cellSize.width);

    if (self.numColumns > 1) {
        spacing = spacing / (self.numColumns - 1);
    }

    CGFloat originX = floorf(self.cellInsets.left + (self.cellSize.width + spacing) * column);
    CGFloat originY = floor(self.cellInsets.top + (self.cellSize.height + self.titleHeight + self.interCellSpacing) * row);
    return CGRectMake(originX, originY, self.cellSize.width, self.cellSize.height);
}

- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    return frame;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];

    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[@"AlbumCell"][indexPath];
}

/*
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[@"AlbumTitle"][indexPath];
}
 */

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numColumns;
    if ([self.collectionView numberOfSections] % self.numColumns) {
        rowCount++;
    }
    CGFloat height = self.cellInsets.top + rowCount * self.cellSize.height + (rowCount - 1) * self.interCellSpacing + rowCount * self.titleHeight + self.cellInsets.bottom;
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

@end
